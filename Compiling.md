## Introduction ##

This guide will explain how to compile the OpenFlux library into a SWC, so that FluxExamples and custom code utilizing OpenFlux  can easily be compiled.  The SWC can be compiled using Flex Builder or the [compc](http://livedocs.adobe.com/flex/3/html/compilers_22.html#250507) command line tool, but this guide will initially detail how to do so using Flex Builder.  Command line instructions will be added later.  More detailed instructions for compiling Flex applications and components may be found on the [Flex LiveDocs](http://livedocs.adobe.com/flex/3/html/compilers_01.html) page.

### Setup ###

  1. Download the latest [Degrafa](http://degrafa.googlecode.com) SWC.
  1. Checkout the latest [Tweener](http://tweener.googlecode.com) library.
  1. Install [Subclipse](http://subclipse.tigris.org) into Eclipse/Flex Builder.

This guide will assume that [Tweener](http://tweener.googlecode.com) has been checked out to the `C:\libs` folder:

`C:\libs> svn checkout http://tweener.googlecode.com/svn/trunk tweener`

It also assumes that the latest Degrafa SWC has been stored in `C:\libs`.

### Walkthrough ###

#### Checkout OpenFlux Using Subclipse ####

  * Switch to the SVN Repository Perspective:

![http://openflux.googlecode.com/files/SubclipsePerspective.png](http://openflux.googlecode.com/files/SubclipsePerspective.png)

  * Click the Add SVN Repository button: ![http://openflux.googlecode.com/files/AddSVNIcon.png](http://openflux.googlecode.com/files/AddSVNIcon.png)
  * Enter `http://openflux.googlecode.com/svn/trunk/` into the URL text box and click **Finish**:

![http://openflux.googlecode.com/files/OpenFluxRepositoryLocation.png](http://openflux.googlecode.com/files/OpenFluxRepositoryLocation.png)

  * Expand the **+** icon next to `http://openflux.googlecode.com/svn/trunk` in the _SVN Repository_ panel.
  * Right-click on the **OpenFlux** folder.
  * Select **Checkout...**

![http://openflux.googlecode.com/files/CheckoutOpenFlux.png](http://openflux.googlecode.com/files/CheckoutOpenFlux.png)

  * Click **Finish** keeping the default settings to checkout the OpenFlux Head revision using the _New Project Wizard_:

![http://openflux.googlecode.com/files/CheckoutOpenFluxUsingNewProjectWizard.png](http://openflux.googlecode.com/files/CheckoutOpenFluxUsingNewProjectWizard.png)

  * Expand the _Flex Builder_ folder and select **Flex Library Project** in the _Select a wizard_ screen and click **Next >**:

![http://openflux.googlecode.com/files/SelectFlexLibraryProject.png](http://openflux.googlecode.com/files/SelectFlexLibraryProject.png)

  * Name the project **OpenFlux** and click **Finish**:

![http://openflux.googlecode.com/files/NameFlexLibraryProject.png](http://openflux.googlecode.com/files/NameFlexLibraryProject.png)

  * If prompted to switch to the Flex Development perspective, click **Yes**:

![http://openflux.googlecode.com/files/SwitchToFlexPerspective.png](http://openflux.googlecode.com/files/SwitchToFlexPerspective.png)

  * Click **OK** in the _Confirm Overwrite_ prompt:

![http://openflux.googlecode.com/files/ConfirmOverwrite.png](http://openflux.googlecode.com/files/ConfirmOverwrite.png)

#### Modify Flex Compiler Settings ####

  * Right-click **OpenFlux** in the Flex Navigator panel and select **Properties**:

![http://openflux.googlecode.com/files/RightClickProperties.png](http://openflux.googlecode.com/files/RightClickProperties.png)

  * Click on **Flex Library Build Path** in the left half of the _Properties_ window.
  * Click the **Classes** tab if it is not selected.
  * Click the **com** checkbox so that it is checked:

![http://openflux.googlecode.com/files/SelectComFolderInBuildPathTab.png](http://openflux.googlecode.com/files/SelectComFolderInBuildPathTab.png)

  * Click the **Source path** tab.
  * Click the **Add Folder...** button:

![http://openflux.googlecode.com/files/AddFolderInSourcePathTab.png](http://openflux.googlecode.com/files/AddFolderInSourcePathTab.png)

  * Click **Browse...** in the _Add Folder_ window.
  * Browse to the location of the _Tweener_ library.
  * Select the **as3** folder within the _Tweener_ library and click **OK**:

![http://openflux.googlecode.com/files/BrowseToAS3TweenerFolder.png](http://openflux.googlecode.com/files/BrowseToAS3TweenerFolder.png)

  * Click **OK** in the _Add Folder_ window:

![http://openflux.googlecode.com/files/ClickOKInAddFolderWindow.png](http://openflux.googlecode.com/files/ClickOKInAddFolderWindow.png)

  * Click the **Library path** tab.
  * Click the **Add SWC...** button:

![http://openflux.googlecode.com/files/AddSWCInLibraryPathTab.png](http://openflux.googlecode.com/files/AddSWCInLibraryPathTab.png)

  * Click **Browse...** in the _Add SWC_ window.
  * Browse to the location of the Degrafa SWC (`Degrafa_Beta2_3.0.swc` at the time of writing this guide).
  * Select the latest Degrafa SWC and click **Open**:

![http://openflux.googlecode.com/files/SelectDegrafaSWC.png](http://openflux.googlecode.com/files/SelectDegrafaSWC.png)

  * Click **OK** in the _Add SWC_ window:

![http://openflux.googlecode.com/files/ClickOKInAddSWCWindow.png](http://openflux.googlecode.com/files/ClickOKInAddSWCWindow.png)

  * Click on **Flex Library Compiler** in the left half of the _Properties_ window.
  * Enter `http://openflux.googlecode.com` into the _Namespace URL_ text box.
  * Enter `-compiler.keep-as3-metadata+=ModelAlias,ViewContract,ViewHandler,EventHandler,StyleBinding` into the _Additional compiler arguments_ text box:

![http://openflux.googlecode.com/files/ModifyFlexLibraryCompilerSettings.png](http://openflux.googlecode.com/files/ModifyFlexLibraryCompilerSettings.png)

  * Click **Browse...** to the right of the _Manifest file_ text box.
  * Select **manifest.xml** in the _Select Manifest File_ window.
  * Click **OK**:

![http://openflux.googlecode.com/files/SelectManifestXML.png](http://openflux.googlecode.com/files/SelectManifestXML.png)

  * Click **Apply**.
  * Click **OK**.
  * Build the project and `OpenFlux.swc` will be created in the _bin_ folder of the project.
  * Celebrate!  It's time to start having fun with OpenFlux!

### Use OpenFlux.swc to Compile an OpenFlux Project ###

Simply include `OpenFlux.swc` in any project and the project will compile.