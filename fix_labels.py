import glob
import re

for filepath in glob.glob("docker/*/Dockerfile.*"):
    with open(filepath, 'r') as f:
        content = f.read()

    # We want to match the whole LABEL block that has the release-please comment
    # and split it.

    # Find the org.opencontainers.image.vendor="Snowdream Tech" \
    # # x-release-please-start-version
    #     org.opencontainers.image.version="${VERSION:-0.9.8}" \
    # # x-release-please-end
    #     org.opencontainers.image.created="${BUILDTIME}" \
    #     org.opencontainers.image.revision="${REVISION}" \
    #     org.opencontainers.image.url="https://github.com/snowdreamtech/rtorrent"

    pattern = r'(org\.opencontainers\.image\.vendor="[^"]+"\s*\\)\n# x-release-please-start-version\n\s*org\.opencontainers\.image\.version="([^"]+)"\s*\\\n# x-release-please-end\n'

    def repl(m):
        vendor_line = m.group(1)
        version_val = m.group(2)
        # we remove the backslash from url line later, but here we just restructure
        # Actually wait, the last line in the block is url="...". We need to remove the trailing slash from vendor?
        # No, because created, revision, url come after it.
        # Wait, if we move it to the bottom:
        # org.opencontainers.image.url="..." (no slash)
        #
        # # x-release-please-start-version
        # LABEL org.opencontainers.image.version="..."
        # # x-release-please-end
        return vendor_line + '\n'

    content_new = re.sub(pattern, repl, content)

    # But wait, now the version label is completely removed. We need to append it after the LABEL block.
    # Let's do it more robustly.

    # 1. extract the version line value.
    m = re.search(r'# x-release-please-start-version\n\s*org\.opencontainers\.image\.version="([^"]+)"\s*\\\n# x-release-please-end\n', content)
    if m:
        version_val = m.group(1)
        # remove the release-please block entirely from inside LABEL
        content = re.sub(r'# x-release-please-start-version\n\s*org\.opencontainers\.image\.version="[^"]+"\s*\\\n# x-release-please-end\n', '', content)

        # Now find the end of the LABEL block (the line without a trailing slash)
        # It's usually: org.opencontainers.image.url="https://github.com/snowdreamtech/rtorrent"
        content = re.sub(
            r'(org\.opencontainers\.image\.url="[^"]+")\n',
            r'\1\n\n# x-release-please-start-version\nLABEL org.opencontainers.image.version="' + version_val + r'"\n# x-release-please-end\n',
            content
        )

        with open(filepath, 'w') as f:
            f.write(content)
