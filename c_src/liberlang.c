#include <string.h>

#include "liberlang.h"

/* Take the String on stack and convert it to atom
 *
 * Works by having a user data in which we store the string, and its metatable
 * is erlang.mt_atom
 */
static int e_atom(lua_State *L) {
    const char *str;
    size_t len;

    char *userdata;

    luaL_checkstring(L, 1);
    str = lua_tolstring(L, 1, &len);

    userdata = (char*)lua_newuserdata(L, len+1);
    memcpy(userdata, str, len+1);

    lua_getglobal(L, "erlang");
    lua_getfield(L, -1, "t_atom");
    lua_setmetatable(L, 2);
    lua_pop(L, 1);
    return 1;
}

static const struct luaL_Reg liberlang[] = {
    {"atom", e_atom},
    {NULL, NULL}
};

int luaopen_liberlang(lua_State *L) {
    lua_newtable(L);

#if LUA_VERSION_NUM > 501
    luaL_setfuncs (L, liberlang, 0);
#else
    luaL_register(L, NULL, liberlang);
#endif

    /* Create metatable "erlang.t_atom" */
    lua_pushstring(L, "t_atom");
    lua_newtable(L);
    lua_settable(L, -3);

    lua_setglobal(L, "erlang");
    return 0;
}
