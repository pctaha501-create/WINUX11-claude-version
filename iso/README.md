# WINUX11 ISO infrastructure

ISO generation is intentionally a final-stage operation. This directory contains the reproducible image layout and build entry point, but normal CI does not invoke it.

Before an image build, the release checklist requires a green core build, green tests, successful installation validation, a tested display-manager session, and a manual desktop smoke test.
