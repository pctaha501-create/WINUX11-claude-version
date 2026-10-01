# Security Center data model

The security service reports observable host state only: listening sockets, active TCP/UDP connections and available firewall backends. It does not claim that a machine is secure merely because a service is active.

Command execution is bounded and failure-aware. Missing utilities are represented as unavailable.
