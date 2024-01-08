输出存档和输出数据流相似。可以用<<或&操作符将数据保存到存档  
``` c++
ar << data;
ar & data;
```
输入存档和输出数据流相似。可以用>>或&操作符从归档文件中加载数据
``` c++
ar >> data;
ar & data;
```
当为基本数据类型调用这些操作符时，数据只是保存/加载到/从存档中。当为类数据类型调用时，将调用类序列化函数。每个序列化函数都使用上述操作符保存/加载其数据成员。这个过程将以递归的方式继续，直到保存/加载类中包含的所有数据。

# 一个非常简单的例子  

这些操作符在序列化函数中用于保存和加载类数据成员。  

这个库中包含了一个名为demo.cpp的程序，它演示了如何使用这个系统。下面我们从这个程序中摘录代码，以尽可能简单的情况说明如何使用这个库。  
``` c++
#include <fstream>

// include headers that implement a archive in simple text format
#include <boost/archive/text_oarchive.hpp>
#include <boost/archive/text_iarchive.hpp>

/////////////////////////////////////////////////////////////
// gps coordinate
//
// illustrates serialization for a simple type
//
class gps_position
{
private:
    friend class boost::serialization::access;
    // When the class Archive corresponds to an output archive, the
    // & operator is defined similar to <<.  Likewise, when the class Archive
    // is a type of input archive the & operator is defined similar to >>.
    template<class Archive>
    void serialize(Archive & ar, const unsigned int version)
    {
        ar & degrees;
        ar & minutes;
        ar & seconds;
    }
    int degrees;
    int minutes;
    float seconds;
public:
    gps_position(){};
    gps_position(int d, int m, float s) :
        degrees(d), minutes(m), seconds(s)
    {}
};

int main() {
    // create and open a character archive for output
    std::ofstream ofs("filename");

    // create class instance
    const gps_position g(35, 59, 24.567f);

    // save data to archive
    {
        boost::archive::text_oarchive oa(ofs);
        // write class instance to archive
        oa << g;
    	// archive and stream closed when destructors are called
    }

    // ... some time later restore the class instance to its orginal state
    gps_position newg;
    {
        // create and open an archive for input
        std::ifstream ifs("filename");
        boost::archive::text_iarchive ia(ifs);
        // read class state from archive
        ia >> newg;
        // archive and stream closed when destructors are called
    }
    return 0;
}
```
对于通过序列化保存的每个类，必须存在一个函数来保存定义类状态的所有类成员。对于通过序列化加载的每个类，必须存在一个函数以与保存它们相同的顺序加载这些类成员。在上面的例子中，这些函数是由模板成员函数serialize生成的。  

# 非入侵式版本  

上述提法具有侵入性。也就是说，它要求更改要序列化其实例的类。这在某些情况下可能不方便。该制度允许的另一种相当的提法是:  
``` c++
#include <boost/archive/text_oarchive.hpp>
#include <boost/archive/text_iarchive.hpp>

class gps_position
{
public:
    int degrees;
    int minutes;
    float seconds;
    gps_position(){};
    gps_position(int d, int m, float s) :
        degrees(d), minutes(m), seconds(s)
    {}
};

namespace boost {
namespace serialization {

template<class Archive>
void serialize(Archive & ar, gps_position & g, const unsigned int version)
{
    ar & g.degrees;
    ar & g.minutes;
    ar & g.seconds;
}

} // namespace serialization
} // namespace boost
```
在这种情况下，生成的序列化函数不是gps_position类的成员。这两种公式的作用方式完全相同。  
非侵入式序列化的主要应用是允许在不更改类定义的情况下为类实现序列化。为了实现这一点，类必须公开足够的信息来重建类状态。在本例中，我们假定类具有公共成员——这种情况并不常见。只有公开足够信息以保存和恢复类状态的类才可以序列化，而不需要更改类定义。  
# 序列化成员
具有可序列化成员的可序列化类看起来像这样:  
``` c++
class bus_stop
{
    friend class boost::serialization::access;
    template<class Archive>
    void serialize(Archive & ar, const unsigned int version)
    {
        ar & latitude;
        ar & longitude;
    }
    gps_position latitude;
    gps_position longitude;
protected:
    bus_stop(const gps_position & lat_, const gps_position & long_) :
    latitude(lat_), longitude(long_)
    {}
public:
    bus_stop(){}
    // See item # 14 in Effective C++ by Scott Meyers.
    // re non-virtual destructors in base classes.
    virtual ~bus_stop(){}
};
```
也就是说，类类型的成员就像基本类型的成员一样被序列化。  

注意，使用归档操作符之一保存类bus_stop的实例将调用保存纬度和经度的序列化函数。通过在gps_position的定义中调用serialize，可以依次保存其中的每一个。通过这种方式，归档操作符的应用程序将整个数据结构保存到它的根项。  

# 派生类  

派生类应该包括其基类的序列化。  
``` c++
#include <boost/serialization/base_object.hpp>

class bus_stop_corner : public bus_stop
{
    friend class boost::serialization::access;
    template<class Archive>
    void serialize(Archive & ar, const unsigned int version)
    {
        // serialize base class information
        ar & boost::serialization::base_object<bus_stop>(*this);
        ar & street1;
        ar & street2;
    }
    std::string street1;
    std::string street2;
    virtual std::string description() const
    {
        return street1 + " and " + street2;
    }
public:
    bus_stop_corner(){}
    bus_stop_corner(const gps_position & lat_, const gps_position & long_,
        const std::string & s1_, const std::string & s2_
    ) :
        bus_stop(lat_, long_), street1(s1_), street2(s2_)
    {}
};
```
注意基类与派生类的序列化。不要直接调用基类的序列化函数。这样做似乎可行，但会绕过跟踪写入存储的实例以消除冗余的代码。它还将绕过将类版本信息写入归档文件的过程。出于这个原因，建议总是将成员序列化函数设为私有。声明好友boost::serialization::access将授予序列化库对私有成员变量和函数的访问权限。  

# 指针  

假设我们将公交路线定义为公交站点数组。考虑到  

    1. 我们可能有几种类型的公交车站(记住，bus_stop是一个基类)  
    2. 给定的bus_stop可能出现在多个路由中。  

用指向bus_stop的指针数组表示公交路线很方便。  
``` c++
class bus_route
{
    friend class boost::serialization::access;
    bus_stop * stops[10];
    template<class Archive>
    void serialize(Archive & ar, const unsigned int version)
    {
        int i;
        for(i = 0; i < 10; ++i)
            ar & stops[i];
    }
public:
    bus_route(){}
};
```
数组的每个成员都将被序列化。但是记住，每个成员都是一个指针——那么这到底是什么意思呢?这种序列化的全部目的是允许在另一个地点和时间重建原始数据结构。为了用指针实现这一点，仅仅保存指针的值是不够的，还必须保存指针指向的对象。当稍后加载成员时，必须创建一个新对象，并将一个新指针加载到类成员中。  

如果同一个指针序列化了不止一次，则只会将一个实例添加到归档中。回读时，不回读任何数据。唯一发生的操作是将第二个指针设置为等于第一个指针  

注意，在本例中，数组由多态指针组成。也就是说，每个数组元素都指向几种可能的公交车站之一。因此，当保存指针时，必须保存某种类标识符。在加载指针时，必须读取类标识符，并且必须构造相应类的实例。最后，可以将数据加载到新创建的正确类型的实例中。从demo.cpp中可以看出，通过基类指针序列化指向派生类的指针可能需要显式枚举要序列化的派生类。这被称为派生类的“注册”或“导出”。本文详细阐述了这一要求以及满足这一要求的方法。  

所有这些都是由序列化库自动完成的。上面的代码就是全部必须完成保存和加载通过指针访问的对象。  

# 数组  

事实上，上述公式过于复杂了。序列化库检测被序列化的对象何时为数组，并发出与上述代码等效的代码。所以以上可以缩写为:  
``` c++
class bus_route
{
    friend class boost::serialization::access;
    bus_stop * stops[10];
    template<class Archive>
    void serialize(Archive & ar, const unsigned int version)
    {
        ar & stops;
    }
public:
    bus_route(){}
};
```

# STL容器  

上面的例子使用了一个成员数组。这样的应用程序更有可能为此目的使用STL集合。序列化库包含所有STL类的序列化代码。因此，下面的重新表述也将如人们所期望的那样工作。  
``` c++
#include <boost/serialization/list.hpp>

class bus_route
{
    friend class boost::serialization::access;
    std::list<bus_stop *> stops;
    template<class Archive>
    void serialize(Archive & ar, const unsigned int version)
    {
        ar & stops;
    }
public:
    bus_route(){}
};

```

# 类版本控制  

假设我们对bus_route类感到满意，构建一个使用它的程序并发布产品。一段时间后，决定程序需要增强，并且修改bus_route类以包含路由驱动程序的名称。所以新版本是这样的:  
``` c++
#include <boost/serialization/list.hpp>
#include <boost/serialization/string.hpp>

class bus_route
{
    friend class boost::serialization::access;
    std::list<bus_stop *> stops;
    std::string driver_name;
    template<class Archive>
    void serialize(Archive & ar, const unsigned int version)
    {
        ar & driver_name;
        ar & stops;
    }
public:
    bus_route(){}
};
```
太好了，我们都做完了。除了……使用我们的应用程序的人现在有一堆在前一个程序下创建的文件。这些如何与我们的新程序版本一起使用?  
通常，序列化库在归档文件中为每个序列化的类存储一个版本号。默认情况下，此版本号为o。当加载归档文件时，它所属的版本号已保存的是读的。可以修改上面的代码来利用这一点  
``` c++
#include <boost/serialization/list.hpp>
#include <boost/serialization/string.hpp>
#include <boost/serialization/version.hpp>

class bus_route
{
    friend class boost::serialization::access;
    std::list<bus_stop *> stops;
    std::string driver_name;
    template<class Archive>
    void serialize(Archive & ar, const unsigned int version)
    {
        // only save/load driver_name for newer archives
        if(version > 0)
            ar & driver_name;
        ar & stops;
    }
public:
    bus_route(){}
};

BOOST_CLASS_VERSION(bus_route, 1)
```
通过对每个类应用版本控制，就不需要尝试维护文件的版本控制。也就是说，文件版本是其所有组成类的版本的组合。这个系统允许程序总是与所有以前版本的程序创建的存档兼容，而不需要比这个例子所要求的更多的努力。  

# 拆分序列化成save/load  

serialize函数简单、简洁，并保证以相同的顺序保存和加载类成员——这是序列化系统的关键。但是，在某些情况下，加载和保存操作并不像这里使用的示例那样相似。例如，这可能发生在经过多个版本进化的类上。上述类可以重新表述为:
``` c++
#include <boost/serialization/list.hpp>
#include <boost/serialization/string.hpp>
#include <boost/serialization/version.hpp>
#include <boost/serialization/split_member.hpp>

class bus_route
{
    friend class boost::serialization::access;
    std::list<bus_stop *> stops;
    std::string driver_name;
    template<class Archive>
    void save(Archive & ar, const unsigned int version) const
    {
        // note, version is always the latest when saving
        ar  & driver_name;
        ar  & stops;
    }
    template<class Archive>
    void load(Archive & ar, const unsigned int version)
    {
        if(version > 0)
            ar & driver_name;
        ar  & stops;
    }
    BOOST_SERIALIZATION_SPLIT_MEMBER()
public:
    bus_route(){}
};

BOOST_CLASS_VERSION(bus_route, 1)
```
宏BOOST SERIALIZATION SPLIT MEMBER()生成调用保存或加载的代码，具体取决于存档是用于保存还是加载。  

# 存档  
我们在这里讨论的重点是向类中添加序列化功能。要序列化的数据的实际呈现在归档类中实现。因此，序列化数据流是类的序列化和所选存档的产物。这两个组件是独立的是一个关键的设计决策。这允许任何序列化规范可用于任何存档。  
在本教程中，我们使用了一个特殊的归档类——text_oarchive用于保存，text_iarchive用于加载。文本存档将数据呈现为文本，并且可以跨平台移植。除了文本归档之外，该库还包括原生二进制数据和xml格式数据的归档类。所有归档类的接口都是相同的。一旦为类定义了序列化，就可以将该类序列化为任何类型的归档文件。  
如果当前的归档类集不提供特定应用程序所需的属性、格式或行为，则可以创建新的归档类或从现有的归档类派生。这将在手册后面进行描述。  