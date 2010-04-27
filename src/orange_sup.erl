%% Copyright 2009-2010 Nicolas R Dufour.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%
%% @author Nicolas R Dufour <nrdufour@gmail.com>
%% @copyright 2009-2010 Nicolas R Dufour.

-module(orange_sup).
-behavior(supervisor).
-author('Nicolas R Dufour <nrdufour@gmail.com>').

-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link(?MODULE, nil).

init(_InitArgs) ->
    %% Install my personal error handler
    %%gen_event:swap_handler(alarm_handler,
    %%            {alarm_handler, swap},
    %%            {my_alarm_handler, xyz}),

    ClassManager = {orange_class,
            {orange_class, start_link, []},
            permanent,
            10000,
            worker,
	    [orange_class]},
    
    AttributeManager = {orange_attribute,
            {orange_attribute, start_link, []},
            permanent,
            10000,
            worker,
	    [orange_attribute]},
    
    LinkManager = {orange_link,
            {orange_link, start_link, []},
            permanent,
            10000,
            worker,
	    [orange_link]},
    
    ObjectManager = {orange_object,
            {orange_object, start_link, []},
            permanent,
            10000,
            worker,
	    [orange_object]},
    
    StorageManager = {orange_storage_server,
            {orange_storage_server, start_link, []},
            permanent,
            10000,
            worker,
	    [orange_storage_server]},

    Strategies = {
        {one_for_one, 10, 3600},
        [ClassManager, AttributeManager, LinkManager, ObjectManager, StorageManager]
    },
    
    {ok, Strategies}.

