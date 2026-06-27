import glob

for filepath in glob.glob("docker/*/Dockerfile.rutorrent"):
    with open(filepath, 'r') as f:
        content = f.read()
    
    # fix the messed up line
    # && rm -rfv ruTorrent-${RUTORRENT_VERSION}&& rm -rfv ruTorrent-${RUTORRENT_VERSION} rm -rfv ruTorrent-${RUTORRENT_VERSION} \
    # to
    # && rm -rfv ruTorrent-${RUTORRENT_VERSION} \
    content = content.replace(
        "&& rm -rfv ruTorrent-${RUTORRENT_VERSION}&& rm -rfv ruTorrent-${RUTORRENT_VERSION} rm -rfv ruTorrent-${RUTORRENT_VERSION} \\", 
        "&& rm -rfv ruTorrent-${RUTORRENT_VERSION} \\"
    )
    
    with open(filepath, 'w') as f:
        f.write(content)
