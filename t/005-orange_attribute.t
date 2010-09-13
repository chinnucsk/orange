#!/usr/bin/env escript
%% -*- erlang -*-
%%! -pa ./ebin -pa ./t

main(_) ->
    etap:plan(unknown),
    etap:loaded_ok(orange_attribute, "Module 'orange_attribute' loaded."),
    etap:has_attrib(orange_attribute, behavior),
    etap:is_attrib(orange_attribute, behavior, gen_server),
    etap:can_ok(orange_attribute, create),
    etap:can_ok(orange_attribute, create, 2),
    etap:can_ok(orange_attribute, create, 3),
    etap:can_ok(orange_attribute, hibern),
    etap:can_ok(orange_attribute, hibern, 2),
    etap:can_ok(orange_attribute, awake),
    etap:can_ok(orange_attribute, awake, 2),
    etap:can_ok(orange_attribute, destroy),
    etap:can_ok(orange_attribute, destroy, 2),
    etap:can_ok(orange_attribute, resur),
    etap:can_ok(orange_attribute, resur, 2),
    etap:can_ok(orange_attribute, purge),
    etap:can_ok(orange_attribute, purge, 2),

    application:start(orange),
    orange_storage_server:init_storage(),

    % First create a class
    orange_class:create("Bridge"),

    % Try to create an attribute
    etap:is(orange_attribute:create("Bridge", "height"), {ok, alive}, "Creating Attribute Bridge.height"),

    % Changing the adt state
    etap:is(orange_attribute:hibern("Bridge", "height"), {ok, frozen}, "Freezing Attribute Bridge.height"),
    etap:is(orange_attribute:awake("Bridge", "height"), {ok, alive}, "Unfreezing Attribute Bridge.height"),
    etap:is(orange_attribute:destroy("Bridge", "height"), {ok, destroyed}, "Destroying Attribute Bridge.height"),
    etap:is(orange_attribute:resur("Bridge", "height"), {ok, alive}, "Resurecting Attribute Bridge.height"),

    % Try to create an attribute in a class that doesnt exist
    etap:is(orange_attribute:create("Nope", "height"), {error, invalid_parents}, "Can't create Nope.height"),

    % Try to recreate the same attribute in the same class
    etap:is(orange_attribute:create("Bridge", "height"), {error, already_exists}, "Can't create the same attribute twice"),

    application:stop(orange),

    etap:end_tests(),
    ok.

