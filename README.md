Lela iOS Perceptual Difference Testing Framework
=====================================

KIF is great.  KIF lets you keep your app functional, encourages you to use accessibility, etc.  One weakness KIF has is that it does not tell you if your app has *visually* changed.  You still need testers manually going through, eyeballing your app and asking "Does this match the wireframes?"

**Lela is here to help KIF out!** Lela, which stands for Less Eyeballing Large Apps, is a library built on top of KIF which tells you if your screens have changed.  Lela has distinct image names for screen size, density, OS version, and device idiom, meaning your can plug a bunch of different devices into your CI server and Lela can validate all of them.

**Important Note:** Lela uses GPL licensed code from [Perceptual Image Diff](http://pdiff.sourceforge.net). In most cases this shouldn't matter since you're not distributing your tests, but if you fork the project or plan on packaging it in a product that's something keep that in mind.

See Lela in Action
------------------

Lela comes with a demo project showing the three different result modes (pass, image doesn't meet expectations, expectations image missing) for a non-retina iOS 6.1 simulator. I know that's specific, but that's what it takes!

![Test results](https://github.com/kif-framework/Lela/raw/master/Images/Test Results.png)

One important thing you'll notice is that tests don't stop when Lela detects a mismatch.  Since a broken appearance doesn't imply a broken UI, the tests keep going to let your gather more screens and exit tests in a stable place.

Using Lela in Your Workflow
---------------------------
Lela is most powerful when it can be used by your business partners to sign off on a part of the app.  Here is one way to go about it.

1. You get a new user story with wireframes.  You code it and you code your KIF tests.  You insert Lela test steps with logical names like "Login screen", "Login failed", etc.
2. These tests will fail and generate useful images with names like "Login screen-320x480@1x~iphone,iOS6.1.png" in your application's documents directory under a test run folder.  (The path will appear in the test logs.)
3. Bundle up the images, send them to your business partner and ask if they're good.
4. When everyone's happy, copy the images into your test bundle.  The tests won't fail anymore (assuming the UI stays the same).

When a change occurs, either intentional or unintentional, you will get a test error with three files, Expected, Actual, and Difference.  If it's due to a bug, fix it!  If not, send the screenshots to your business partners again.  Once you get sign off, copy the approved images into your test bundle and you're set.

![Three output files showing differences](https://github.com/kif-framework/Lela/raw/master/Images/Differences.png)

You may want to use your existing KIF test target for these files or create a new one.  It really depends on whether or not you're comfortable seeing a bunch of test failures on your KIF tests in the production server.

Installation
------------

Lela can be installed with a [CocoaPods](http://cocoapods.org).

```Ruby
target 'Acceptance Tests' do
  pod 'Lela', '~> 0.2'
end
```

Example
-------

This example assumes you are already familiar with KIF and borrows from the example on that project.  There are really only two things you need to do.

1. Add the Lela header to your test case file:

    ```objc
    #import <Lela/Lela.h>
    ```

2. Add `expectScreenToMatchImageNamed:` steps to your tests.

    ```objc
    - (void)testSuccessfulLogin
    {
        [tester enterText:@"user@example.com" intoViewWithAccessibilityLabel:@"Login User Name"];
        [tester enterText:@"thisismypassword" intoViewWithAccessibilityLabel:@"Login Password"];
        [tester tapViewWithAccessibilityLabel:@"Log In"];

        // Test that the login screen looks correct.
        [tester expectScreenToMatchImageNamed:@"Filled Out Login Screen"];

        // Verify that the login succeeded
        [tester waitForTappableViewWithAccessibilityLabel:@"Welcome"];

        // Test that the welcome screen looks correct.
        [tester expectScreenToMatchImageNamed:@"Welcome screen"];
    }
    ```

You will likely want to add some `waitForTimeInterval:` steps if your views take a moment to stablize.
