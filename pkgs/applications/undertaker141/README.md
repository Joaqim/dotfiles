# UnderTaker141

This module facilitates packaging of the [UnderTaker141](https://github.com/AbdelrhmanNile/UnderTaker141) AppImage into NixOS.

How to update:
When a new update arrives, you need to run nix-prefetch-url to get the SHA of the file to update the module:

```
nix-prefetch-url https://github.com/AbdelrhmanNile/UnderTaker141/releases/download/latest/UnderTaker141.AppImage
```

Then update the section of the module with the current version number and SHA:

```
  # Set Version and SHA
  undertaker141Version = "2.1.3";
  undertaker141SHA = "07iag8siyfkdvy7fxk33nslmzsm1cq6yicdv14l7l1wig6dq536q";
```