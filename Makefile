# Configuration.
VERSION := 2.2.8
MOCK_CONFIG := almalinux-10-aarch64
GPG_KEY := 17489C46EE9B3B4CE81105CC9B402D84BCB567F6

# Packages to build.
PACKAGES := zfs zfs-dkms
#PACKAGES += zfs-kmod

# Files.
TARBALL := SOURCES/zfs-$(VERSION).tar.gz
SOURCE_URL := https://github.com/openzfs/zfs/releases/download/zfs-$(VERSION)/zfs-$(VERSION).tar.gz
SRPMS := $(foreach pkg,$(PACKAGES),SRPMS/$(pkg)-$(VERSION)-1.el10.src.rpm)
RPMS := $(foreach pkg,$(PACKAGES),RPMS/$(pkg)-$(VERSION)-1.el10.src.rpm)

.PHONY: all download srpms rpms sign clean purge

all: sign

download: $(TARBALL)

srpms: $(SRPMS)

rpms: $(RPMS)

sign: rpms
	@echo ">>> Configuring GPG..."
	@echo "%_signature gpg" > ~/.rpmmacros
	@echo "%_gpg_name $(GPG_KEY)" >> ~/.rpmmacros
	@echo ">>> Signing RPMs..."
	@cd RPMS && rpm --addsign *.rpm
	@echo ">>> Build complete! Signed RPMs are in: RPMS/"

clean:
	rm -f SRPMS/*.rpm
	rm -f RPMS/*.rpm

purge: clean
	rm -f $(TARBALL)

# Download source tarball.
$(TARBALL):
	@echo ">>> Downloading zfs-$(VERSION).tar.gz..."
	@wget -P SOURCES $(SOURCE_URL)

# Build source RPMs.
SRPMS/%-$(VERSION)-1.el10.src.rpm: SPECS/%-$(VERSION).spec $(TARBALL)
	@echo ">>> Building $@..."
	@rpmbuild -bs SPECS/$*-$(VERSION).spec

# Build binary RPMs - uses src.rpm in RPMS as marker.
RPMS/%-$(VERSION)-1.el10.src.rpm: SRPMS/%-$(VERSION)-1.el10.src.rpm
	@echo ">>> Building $* with mock..."
	@mock -r $(MOCK_CONFIG) --rebuild $
	@cp /var/lib/mock/$(MOCK_CONFIG)/result/*.rpm RPMS/
