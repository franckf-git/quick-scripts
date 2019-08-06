import sys, socket, sense_hat, threading

sense = sense_hat.SenseHat()


class _IP(object):  # (object) for Python2-compatibility

    @property
    def IP_address(self):
        """Get IP address: Returns either a string containing the IP
        address or the special value None.
        """
        try:
            s = socket.socket(self.socket_family, socket.SOCK_DGRAM)
            s.connect(self.external_IP_and_port)
            answer = s.getsockname()
            s.close()
            return answer[0] if answer else None
        except socket.error:
            return None

    def display_IP_address(self):
        """Print IP address on Sense Hat display"""
        sense.show_message(self.description + ": " + str(self.IP_address))


class IPv4(_IP):
    # I think no actual network communication occurs, so the actual address
    # in external_IP_and_port is moot unless unroutable,
    external_IP_and_port = ('198.41.0.4', 53)  # a.root-servers.net
    socket_family = socket.AF_INET
    description = "IPv4"


class IPv6(_IP):
    # I think no actual network communication occurs, so the actual address
    # in external_IP_and_port is moot unless unroutable,
    external_IP_and_port = ('2001:503:ba3e::2:30', 53)  # a.root-servers.net
    socket_family = socket.AF_INET6
    description = "IPv6"


def main_loop():
    sense.clear()
    while True:
        # Get IP address on each iteration since its value may change
        IPv4().display_IP_address()
        IPv6().display_IP_address()
        # sense.show_message("...Press joystick button to quit...")


if __name__ == '__main__':
    display_thread = threading.Thread(target=main_loop)
    # setting .daemon to True to stop waiting for the remaining SenseHat text,
    display_thread.daemon = True
    display_thread.start()
    try:
        # The Sense Hat's joystick button is mapped to the Return key so,
        user_input = sys.stdin.readline()
    except KeyboardInterrupt:
        pass  # Just drop through to tidy-up/exit
    sense.clear()