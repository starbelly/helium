%%% @doc module hydro_api provides bindings to libhydrogen for Erlang
%%% @end.
-module(hydro_api).

-define(APPNAME, hydro).
-define(LIBNAME, hydro_nif).

-include("hydro.hrl").

-on_load(init/0).

% helpers
-export([bin2hex/1, random_buf_deterministic/2]).

% random data generation
-export([random_buf/1, random_u32/0, random_uniform/1, random_ratchet/0]).

% Generic  hashing
-export([
         hash_hash/2, 
         hash_hash/3, 
         hash_init/1,
         hash_init/2, 
         hash_update/2, 
         hash_final/1, 
         hash_keygen/0
        ]). 

% Key derivation
-export([kdf_keygen/0, kdf_derive_from_key/4]).

% Secret key crypto
-export([         
         secretbox_keygen/0,
         secretbox_encrypt/3,
         secretbox_decrypt/3,
         secretbox_encrypt/4,
         secretbox_decrypt/4,
         secretbox_probe_create/3,
         secretbox_probe_verify/4
        ]).

% Public key crypto
-export([sign_keygen/0, 
         sign_create/3, 
         sign_verify/4,
         sign_init/1,
         sign_update/2, 
         sign_final_create/2,
         sign_final_verify/3]).

% Password hashing

-export([
        pwhash_keygen/0,
        pwhash_deterministic/5,
        pwhash_create/5,
        pwhash_verify/6,
        pwhash_derive_static_key/7,
        pwhash_reencrypt/3,
        pwhash_upgrade/5
        ]).

-spec bin2hex(binary()) -> binary().
bin2hex(Bin) -> 
    {ok, H} = hydro_bin2hex(Bin),
    H.

-spec hash_keygen() -> binary().
hash_keygen() -> 
    hydro_hash_keygen().

-spec hash_hash(msg(), ctx()) -> {ok, binary()} | {error, term()}.
hash_hash(Msg, Context) -> 
    hydro_hash_hash(Msg, Context, <<"">>).

-spec hash_hash(msg(), ctx(), key()) -> {ok, hash()} | {error, term()}.
hash_hash(Msg, Context, Key) -> 
    hydro_hash_hash(Msg, Context, Key).

-spec hash_init(binary()) -> {ok, reference()} | {error, term()}.
hash_init(Context) -> 
    hydro_hash_init(Context, <<"">>).

-spec hash_init(binary(), binary()) -> {ok, reference()} | {error, term()}.
hash_init(Context, Key) -> 
    hydro_hash_init(Context, Key).

-spec hash_update(hash_state(), msg()) -> {ok, hash_state()} | {error, term()}.
hash_update(State, Msg) -> 
    hydro_hash_update(State, Msg).

-spec hash_final(hash_state()) -> {ok, hash()} | {error, term()}.
hash_final(State) -> 
    hydro_hash_final(State).

-spec kdf_keygen() -> binary().
kdf_keygen() -> 
    hydro_kdf_keygen().

-spec pwhash_keygen() -> {ok, binary()}.
pwhash_keygen() -> 
    hydro_pwhash_keygen().

-spec pwhash_deterministic(ctx(),passwd(),master_key(),integer(),ops_limit()) -> any().
pwhash_deterministic(C, P, Mk, S, OpsLimit) -> 
    hydro_pwhash_deterministic(C, P, Mk, S, OpsLimit).

-spec pwhash_create(
          passwd()
        , master_key()
        , ops_limit()
        , mem_limit()
        , thread_limit()) -> {ok, hash()}.
pwhash_create(P, Mk, Ol, Ml, Tl) -> 
    hydro_pwhash_create(P, Mk, Ol, Ml, Tl).

-spec pwhash_verify(
          hash()
        , passwd()
        , master_key()
        , ops_limit()
        , mem_limit()
        , thread_limit()) -> boolean().
pwhash_verify(H, P, Mk, Ol, Ml, Tl) -> 
    hydro_pwhash_verify(H, P, Mk, Ol, Ml, Tl).

-spec pwhash_derive_static_key(
          ctx()
        , hash()
        , passwd()
        , master_key()
        , ops_limit()
        , mem_limit()
        , thread_limit()) -> {ok, key()}.
pwhash_derive_static_key(C, H, P, Mk, Ol, Ml, Tl) -> 
    hydro_pwhash_derive_static_key(C, H, P, Mk, Ol, Ml, Tl).

-spec pwhash_reencrypt(hash(),master_key(),master_key()) -> any().
pwhash_reencrypt(H, M, N) ->
    hydro_pwhash_reencrypt(H, M, N).

-spec pwhash_upgrade(
          hash()
        , msg()
        , ops_limit()
        , mem_limit()
        , thread_limit()) -> {ok, hash()}.
pwhash_upgrade(H, M, Ol, Ml, Tl) ->
    hydro_pwhash_upgrade(H, M, Ol, Ml, Tl).

-spec secretbox_keygen() -> key().
secretbox_keygen() -> 
    hydro_secretbox_keygen().

-spec secretbox_encrypt(ctx(), msg(), key()) -> {ok, hash()} |
                                                         {error, term()}.
secretbox_encrypt(C, M, K) -> 
    hydro_secretbox_encrypt(C, M, 0, K).

-spec secretbox_decrypt(ctx(), hash(), key()) -> {ok, msg()} |
                                                         {error, term()}.
secretbox_decrypt(C, H, K) -> 
    hydro_secretbox_decrypt(C, H, 0, K).

-spec secretbox_encrypt(ctx(), msg(), integer(), key()) -> 
    {ok, hash()} | {error, term()}.
secretbox_encrypt(C, M, I,  K) -> 
    hydro_secretbox_encrypt(C, M, I, K).

-spec secretbox_decrypt(
          ctx()
        , hash()
        , integer()
        , key()) -> {ok, msg()} | {error, term()}.
secretbox_decrypt(C, H, I, K) -> 
    hydro_secretbox_decrypt(C, H, I, K).

-spec secretbox_probe_create(
          ctx()
        , hash() 
        , key()) -> {ok, secretbox_probe()} | {error, term()}.
secretbox_probe_create(C, H, K) -> 
    hydro_secretbox_probe_create(C, H, K).

-spec secretbox_probe_verify(
          ctx()
        , msg()
        , key()
        , secretbox_probe()) -> {ok, binary()} | {error, term()}.
secretbox_probe_verify(C, M, K, P) -> 
    hydro_secretbox_probe_verify(C, M, K, P).

-spec sign_keygen() -> {ok, binary(), binary()}.
sign_keygen() -> 
    hydro_sign_keygen().

-spec sign_create(ctx(), msg(), sign_key()) -> {ok, pub_key()}.
sign_create(C, M, K) -> 
    hydro_sign_create(C, M, K).

-spec sign_verify(ctx(), msg(), sign_key(), pub_key()) -> boolean().
sign_verify(C, M, S, K) -> 
    hydro_sign_verify(C, M, S, K).

-spec sign_init(ctx()) -> {ok, sign_state()}.
sign_init(C) -> 
    hydro_sign_init(C).

-spec sign_update(sign_state(), msg()) -> {ok, sign_state()}.
sign_update(State, M) -> 
    hydro_sign_update(State, M).

-spec sign_final_create(sign_state(), sign_key()) -> {ok, pub_sig()}.
sign_final_create(State, Sk) -> 
    hydro_sign_final_create(State, Sk).

-spec sign_final_verify(sign_state(), pub_sig(), pub_key()) -> {ok, binary()}.
sign_final_verify(State, Sig, Pk) -> 
    hydro_sign_final_verify(State, Sig, Pk).

-spec kdf_derive_from_key(
          ctx()
        , master_key()
        , id()
        , integer()) -> {ok, binary()} | {error, term()}.
kdf_derive_from_key(Ctx, Master, SubId, Size) ->
    hydro_kdf_derive_from_key(Ctx, Master, SubId, Size).

-spec random_buf(buf_size()) -> binary().
random_buf(N) when N >= 0 ->
    hydro_random_buf(N).

-spec random_buf_deterministic(buf_size(), rnd_seed()) -> binary().
random_buf_deterministic(Size, Seed) when Size >= 0 ->
    hydro_random_buf_deterministic(Size, Seed).

-spec random_uniform(buf_size()) -> non_neg_integer().
random_uniform(N) when N >= 0 ->
    hydro_random_uniform(N).

-spec random_ratchet() -> ok.
random_ratchet() ->
    hydro_random_ratchet().

-spec random_u32() -> integer().
random_u32() ->
    hydro_random_u32().

%%% @private
init() ->
  SoName = case code:priv_dir(?APPNAME) of
        {error, bad_name} ->
            case filelib:is_dir(filename:join(["..", priv])) of
                true ->
                    filename:join(["..", priv, ?LIBNAME]);
                _ ->
                    filename:join([priv, ?LIBNAME])
            end;
        Dir ->
            filename:join(Dir, ?LIBNAME)
    end,
    erlang:load_nif(SoName, 0).

hydro_bin2hex(_Bin) -> 
    erlang:nif_error(nif_not_loaded).

hydro_hash_keygen() -> 
    erlang:nif_error(nif_not_loaded).

hydro_hash_hash(_Msg, _Ctx, _Key) -> 
    erlang:nif_error(nif_not_loaded).

hydro_hash_init(_Ctx, _Key) -> 
    erlang:nif_error(nif_not_loaded).

hydro_hash_update(_State, _Msg) -> 
    erlang:nif_error(nif_not_loaded).

hydro_hash_final(_State) -> 
    erlang:nif_error(nif_not_loaded).

hydro_kdf_keygen() -> 
    erlang:nif_error(nif_not_loaded).

hydro_kdf_derive_from_key(_Ctx, _M, _Id, _S) -> 
    erlang:nif_error(nif_not_loaded).

hydro_pwhash_keygen() -> 
    erlang:nif_error(nif_not_loaded).

hydro_pwhash_deterministic(_C, _P, _Mk, _S, _Ol) -> 
    erlang:nif_error(nif_not_loaded).

hydro_pwhash_create( _P, _Mk, _Ol, _Ml, _Tl) -> 
    erlang:nif_error(nif_not_loaded).

hydro_pwhash_verify(_H, _P, _Mk, _Ol, _Ml, _Tl) -> 
    erlang:nif_error(nif_not_loaded).

hydro_pwhash_derive_static_key(_C, _H, _P, _Mk, _Ol, _Ml, _Tl) -> 
    erlang:nif_error(nif_not_loaded).

hydro_pwhash_reencrypt(_H, _Mk, _Nmk) -> 
    erlang:nif_error(nif_not_loaded).

hydro_pwhash_upgrade(_H, _Mk, _Ol, _Ml, _Tl) -> 
    erlang:nif_error(nif_not_loaded).

hydro_secretbox_keygen() -> 
    erlang:nif_error(nif_not_loaded).

hydro_secretbox_encrypt(_C, _M, _I, _K) -> 
    erlang:nif_error(nif_not_loaded).

hydro_secretbox_decrypt(_C, _H, _I, _K) -> 
    erlang:nif_error(nif_not_loaded).

hydro_secretbox_probe_create(_C, _H, _K) -> 
    erlang:nif_error(nif_not_loaded).

hydro_secretbox_probe_verify(_C, _H, _K, _P) -> 
    erlang:nif_error(nif_not_loaded).

hydro_sign_keygen() -> 
    erlang:nif_error(nif_not_loaded).

hydro_sign_create(_C, _M, _K) -> 
    erlang:nif_error(nif_not_loaded).

hydro_sign_verify(_C, _M, _S, _K) -> 
    erlang:nif_error(nif_not_loaded).

hydro_sign_init(_C) -> 
    erlang:nif_error(nif_not_loaded).

hydro_sign_update(_S, _M) -> 
    erlang:nif_error(nif_not_loaded).

hydro_sign_final_create(_S, _K) -> 
    erlang:nif_error(nif_not_loaded).

hydro_sign_final_verify(_St, _S, _K) -> 
    erlang:nif_error(nif_not_loaded).

hydro_random_buf(_requestedsize) -> 
    erlang:nif_error(nif_not_loaded).

hydro_random_buf_deterministic(_Size, _Seed) -> 
    erlang:nif_error(nif_not_loaded).

hydro_random_uniform(_UpperBound) -> 
    erlang:nif_error(nif_not_loaded).

hydro_random_ratchet() -> 
    erlang:nif_error(nif_not_loaded).

hydro_random_u32() -> 
    erlang:nif_error(nif_not_loaded).
