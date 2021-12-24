packer:
  lookup:
    download:
      version: '1.7.8'
      hash: "sha256=8a94b84542d21b8785847f4cccc8a6da4c7be5e16d4b1a2d0a5f7ec5532faec0"
    templates:
      bento:
        address: https://github.com/chef/bento.git
        revision: 'main'
      kartzone-demo:
        address: https://github.com/kartzone1/kartzone-demo.git
        revision: 'main'
