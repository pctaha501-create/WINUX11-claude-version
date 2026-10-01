# Windows compatibility

The compatibility layer is optional. It detects Wine, wine64 and Proton from the host and can launch an explicitly selected executable. It does not bundle proprietary Windows components.

Prefixes are supplied explicitly so a user can isolate applications. The layer never rewrites the host filesystem into a fake Windows drive without an explicit compatibility configuration.
