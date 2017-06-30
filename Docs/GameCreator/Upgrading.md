# Upgrading

The upgrade process should be straightforward. When the Game Creator detects you are running a newer version, it automatically upgrades all of the core tools defined in the bios.json file. Any changes to those tools are overwritten. 

![image alt text](images/Upgrading_image_0.png)

While the Game Creator moves old tools into the trash during an upgrade, the trash is automatically set to empty on exit. If this value is true, the Game Creator clears the trash when you shut it down.

![image alt text](images/Upgrading_image_1.png)

One last thing, you should take a moment to understand how releases are numbered. The Game Creator uses a standard versioning convention. For example, a build may look like this v0.7.0 which denotes the major version, minor version, and patch number.

![image alt text](images/Upgrading_image_2.png)

Since the Game Creator is still in alpha, the major version is zero. Each new stable release increments the minor version. In between stable releases, are patches which help address bugs in the previous release. Patch versions are not well tested and should be considered "use at your own risk" builds until the next minor release is available.

If stability is a priority, stick to minor builds where the patch value is zero, 0.7.0a for example. Once Game Creator reaches the first major version, v1.0.0, it is considered beta, and at this point, all of the features are locked allowing development to shift focus on bug fixing and optimizations. At v2.0.0 the Game Creator is a release candidate allowing work to begin on the next round of features to help move the platform forward.

