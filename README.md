ZenPlayer-for-iOS
=================

ZenPlayer is originally designed by [simurai](http://lab.simurai.com/zen-player/) with CSS3 and JavaScript.
This version of ZenPlayer is wrote with objective-c using ARC(Auto Reference Counting) for my application called [walknote](http://pkpk.info/app/walknote/).
Its graphics are re-drawn in bigger size, so it's suitable on retina display.
It would be helpful for everyone who wants to implement cool design button with animation like ZenPlayer.


Screenshots
===========

![screenshot01](https://github.com/noradaiko/ZenPlayer-for-iOS/raw/master/screenshot01.png)

![screenshot02](https://github.com/noradaiko/ZenPlayer-for-iOS/raw/master/screenshot02.png)


How to use
==========

1. Add **ZenPlayerButton** directory into your project
2. Add **QuartzCore.framework** into your project
3. Insert `#import "ZenPlayerButton.h"` into your code
4. Just add below code where you'd like:
<pre>
// create new zen player button
self.zenPlayerButton = [[ZenPlayerButton alloc] initWithFrame:CGRectMake(108, 178, 104, 104)];
// listening to tap event on the button
[self.zenPlayerButton addTarget:self
						 action:@selector(zenPlayerButtonDidTouchUpInside:) 
			   forControlEvents:UIControlEventTouchUpInside];
[self.view addSubview:self.zenPlayerButton];
</pre>


Links
=====

* [noradaiko on Twitter](https://twitter.com/noradaiko)
* [odoruinu.net](http://odoruinu.net/)
* [lab.simurai.com](http://lab.simurai.com/)


