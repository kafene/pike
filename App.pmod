#!/usr/bin/pike

import Protocols.HTTP.Server;


class App {
    constant VERSION = "0.1";
    Request request;
    mapping response;

    void create(Request req) {
        request = req;
        response = ([]);

        response->server = "FinServe " + VERSION;
        response->type = "text/html";
        response->error = 200;
        response->data = "";
    }

    void run() {
        response->data = showForm();
        response->data += "<h1>FinServe " + VERSION + "</h1>\n";
        response->data += "<pre>" + sprintf("%O", mkmapping(indices(request), values(request))) + "</pre>\n";
        response->data += "<HR>";
        response->data += "<pre>" + sprintf("%O", mkmapping(indices(App), values(App))) + "</pre>\n";
        request->response_and_finish(response);
    }

    private string showForm() {
        mixed username = request->variables->username;

        function show_username = lambda(string punctuation) {
            punctuation = punctuation ? punctuation : "!";

            return "Hello, " + App::htmlEscape(username) + punctuation;
        };

        if (stringp(username) && strlen(username) > 0) {
            return show_username("...");
        } else {
            return "<form method=\"POST\" action=\"\">" +
                "<input type=\"text\" name=\"username\" " +
                "placeholder=\"enter some username\"><br>" +
                "<input type=\"submit\">\n";
        }
    }

    private static string htmlEscape(string s) {
        return replace(s, ([
            "&": "&amp;",
            "<": "&lt;",
            ">": "&gt;"
        ]));
    }
}
