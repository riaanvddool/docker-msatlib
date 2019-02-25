MSATLIB
=======

Dockerfile for meteosatlib (msatlib) and its msat executable. See https://github.com/ARPA-SIMC/meteosatlib.

Register here to download the Public Wavelet Transform Decompression Library Software:
http://oiswww.eumetsat.int/WEBOPS-cgi/wavelet/register

The file can now be downloaded from the link provided via email. Place the PublicDecompWT.zip file in the same directory as the Dockerfile.

Example:

    wget http://oiswww.eumetsat.org/wavelet/html/1549891155/PublicDecompWT.zip

To build the docker image:

    docker build -t msatlib:1.8-1 .

To run:

    docker run -it --rm msatlib:1.8-1 msat

