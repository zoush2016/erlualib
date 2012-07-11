-module(luam_test).

-include_lib("eunit/include/eunit.hrl").

push_args_empty_table_test() ->
    {ok, L} = lua:new_state(),
    luam:push_args(L, {}),
    ?assertEqual(1, lua:gettop(L)),
    ?assertEqual(0, lua:objlen(L, 1)).

push_args_table1_test() ->
    {ok, L} = lua:new_state(),
    luam:push_args(L, {true, {}, <<"yadda">>}),
    ?assertEqual(1, lua:gettop(L)),
    ?assertEqual(3, lua:objlen(L, 1)),
    lua:pushnumber(L, 1), lua:gettable(L, 1), % push t[1]
    ?assertEqual(boolean, lua:type(L, 2)),
    lua:pushnumber(L, 2), lua:gettable(L, 1), % push t[2]
    ?assertEqual(table, lua:type(L, 3)),
    lua:pushnumber(L, 3), lua:gettable(L, 1), % push t[3]
    ?assertEqual(string, lua:type(L, 4)).

push_args_nested_table_test() ->
    {ok, L} = lua:new_state(),
    luam:push_args(L, {{true}}),
    ?assertEqual(1, lua:gettop(L)),
    lua:pushnumber(L, 1), lua:gettable(L, 1), % push t[1]
    lua:pushnumber(L, 1), lua:gettable(L, 2), % push inner t[1]
    ?assertEqual(boolean, lua:type(L, -1)).

%proplist1_test() -> sah([{1, 1}]).
%proplist2_test() -> sah([{1,1}, {2, 2}]).
%proplist3a_test() -> sah([{1,1},{2,<<"x">>}]).
%proplist3b_test() -> sah([{1,1},{2,'x'}], [{1,1},{2,<<"x">>}]).
%
%tuple1_test() -> sah({1}, [{1, 1}]).
%tuple2_test() -> sah({1,2}, [{1,1}, {1,2}]).
%tuple3a_test() -> sah({1,<<"x">>}, [{1,1},{2,<<"x">>}]).
%tuple3b_test() -> sah({1,'x'}, [{1,1},{2,<<"x">>}]).

%number_test() -> sah(9).
%float_test() -> sah(9.21).
%neg_float_test() -> sah(-9.21).
%binary_test() -> sah(<<"hiho">>).
%atom_test() -> sah(hiho, <<"hiho">>).
%
%%% @doc Single Arg Helper
%sah(Val) ->
%    sah(Val, Val).
%sah(Val, Expect) ->
%    {ok, L} = lua:new_state(),
%    lual:dostring(L, <<"function t(c) return c end">>),
%    ?assertEqual(Expect, lual:call(L, "t", [Val], 1)),
%    lua:close(L).
