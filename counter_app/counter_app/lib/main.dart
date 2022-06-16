import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _selectedIndex = 1;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                var tween =
                    Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0));
                //执行缩放动画
                return MySlideTransition(
                  child: child,
                  position: tween.animate(animation),
                );
              },
              child: Text(
                '$_counter',
                //显示指定key，不同的key会被认为是不同的Text，这样才能执行动画
                key: ValueKey<int>(_counter),
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
      drawer: const MyDrawer(), //抽屉
      bottomNavigationBar: BottomAppBar(
        //底部导航栏
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: Row(
          children: <Widget>[
            //底部导航栏按钮
            IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  //打开B路由
                      Navigator.push(context, PageRouteBuilder(
                        pageBuilder: (
                          BuildContext context,
                          animation,
                          secondaryAnimation,
                        ) {
                          return FadeTransition(
                            opacity: animation,
                            child: Scaffold(
                              appBar: AppBar(
                                title: const Text("主页"),
                              ),
                              body: HeroAnimationRouteB(),
                            ),
                          );
                        },
                      ));
                  setState(() {
                    _selectedIndex = 0;
                  });
                }),
            IconButton(
                icon: const Icon(Icons.business),
                onPressed: () {
                  //打开路由界面
                  Navigator.push(context, PageRouteBuilder(
                        pageBuilder: (
                          BuildContext context,
                          animation,
                          secondaryAnimation,
                        ) {
                          return FadeTransition(
                            opacity: animation,
                            child: Scaffold(
                              appBar: AppBar(
                                title: const Text("数字"),
                              ),
                              body: const ListView2(),
                            ),
                          );
                        },
                      ));
                  setState(() {
                    _selectedIndex = 1;
                  });
                }),
            IconButton(
                icon: const Icon(Icons.schedule),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                }),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround, //均分底部导航栏横向空间
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

//动画切换
class MySlideTransition extends AnimatedWidget {
  const MySlideTransition({
    Key? key,
    required Animation<Offset> position,
    this.transformHitTests = true,
    required this.child,
  }) : super(key: key, listenable: position);

  final bool transformHitTests;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final position = listenable as Animation<Offset>;
    Offset offset = position.value;
    if (position.status == AnimationStatus.reverse) {
      offset = Offset(-offset.dx, offset.dy);
    }
    return FractionalTranslation(
      translation: offset,
      transformHitTests: transformHitTests,
      child: child,
    );
  }
}

//抽屉
class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        //移除抽屉菜单顶部默认留白
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: Row(
                children: <Widget>[
                  InkWell(
                    child: Hero(
                      tag: "avatar", //唯一标记，前后两个路由页Hero的tag必须相同
                      child: ClipOval(
                        child: Image.network(
                          "https://img.zcool.cn/community/0187ee5ae9442fa801207fa1baa2c4.gif",
                          width: 50.0,
                        ),
                      ),
                    ),
                    onTap: () {
                      //打开B路由
                      Navigator.push(context, PageRouteBuilder(
                        pageBuilder: (
                          BuildContext context,
                          animation,
                          secondaryAnimation,
                        ) {
                          return FadeTransition(
                            opacity: animation,
                            child: Scaffold(
                              appBar: AppBar(
                                title: const Text("原图"),
                              ),
                              body: HeroAnimationRouteB(),
                            ),
                          );
                        },
                      ));
                    },
                  ),
                  const Text(
                    "Wendux",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: const <Widget>[
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Add account'),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Manage accounts'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//hero动画
class HeroAnimationRouteB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: "avatar", //唯一标记，前后两个路由页Hero的tag必须相同
        child: Image.network(
          "https://img.zcool.cn/community/0187ee5ae9442fa801207fa1baa2c4.gif",
        ),
      ),
    );
  }
}
//ListView组件
class ListView2 extends StatelessWidget {
  const ListView2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //下划线widget预定义以供复用。
    return ListView.builder(
        itemCount: 100,
        itemExtent: 50.0, //强制高度为50.0
        itemBuilder: (BuildContext context, int index) {
          return ListTile(title: Text("$index"));
        });
  }
}
