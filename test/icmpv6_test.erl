-module(icmpv6_test).

-include_lib("eunit/include/eunit.hrl").
-include("ip.hrl").
-include("test_utils.hrl").

-import(icmpv6, [decode/1, encode/1]).

%--- API -----------------------------------------------------------------------

encode_decode_test_() ->
    ?pcap_packets("test/encode_decode/ipv6/icmpv6", Frame,
        fun() ->
            Packet = test_utils:strip_eth(Frame),
            #ipv6{headers = [{icmpv6, Data}|_]} = IPv6 = ipv6:decode(Packet),
            #ipv6{headers = [Decoded|_]} = icmpv6:decode(IPv6),
            ?assertEqual(Data, iolist_to_binary(encode(Decoded)))
        end
    ).

%--- Internal ------------------------------------------------------------------

strip(Frame) ->
    #ipv6{headers = [{icmpv6, Data}|_]} = ipv6:decode(test_utils:strip_eth(Frame)),
    Data.
