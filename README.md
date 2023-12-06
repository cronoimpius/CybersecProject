# CybersecProject
This is a repo for the Cybersec project of 2023/2024.

The project consist into making a Docker image for a fake ldap server.
This server can autogenerate users (ecc) , import an existing one and can be configurated from the client connections POV.

Inside [exam](./exam) there are the presentation and report.

In [init](./iinit) there are the scripts used and the pregenerated data/configurations.

The [Dockerfile](./Dockerfile) is the final dockerfile wich i've used to generate the oci image.

The [oci-image](https://liveunibo-my.sharepoint.com/:u:/g/personal/gianmiriano_porrazzo_studio_unibo_it/EfXghm-mAYpBtdYUHDoZil4BOBHEHoGS_lX8KUh-HwuMFA?e=ffmGXB) is in the link because it was to big for github.

The result is a OCI compatible image ready to be instantiated
