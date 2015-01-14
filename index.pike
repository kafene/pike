#!/usr/bin/pike

import Protocols.HTTP.Server;
import .App;

int main(int argc, array(string) argv) {
    int server_port;

    if (argc > 1) {
        server_port = (int) argv[1];
    } else {
        server_port = 8080;
    }

    write("FinServe starting on port " + server_port + "\n");

    Port port = Port(lambda(Request request) {
        write(sprintf("got request: %O\n", request));

        App myApp = App(request);

        myApp->run();
    }, server_port);

    return -1;
}
