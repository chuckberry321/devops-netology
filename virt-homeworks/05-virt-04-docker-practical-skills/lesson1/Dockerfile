FROM archlinux

RUN yes | pacman -Syu  && \
    yes | pacman -S ponysay

ENTRYPOINT ["/usr/bin/ponysay"]
CMD ["Hey, netology”]
