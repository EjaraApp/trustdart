import 'dart:typed_data';

import 'package:trustdart/trustdart.dart';
import 'package:trustdart_example/coins.dart';

Map<String, dynamic> operations = {
  'XTZ': {
    "operationList": {
      "branch": "BL8euoCWqNCny9AR3AKjnpi38haYMxjei1ZqNHuXMn19JSQnoWp",
      "operations": [
        {
          "source": "tz1XVJ8bZUXs7r5NV8dHvuiBhzECvLRLR3jW",
          "fee": 1272,
          "counter": 30738,
          "gasLimit": 10100,
          "storageLimit": 257,
          "kind": 107,
          "revealOperationData": {
            "publicKey": "8z6GkG6TaQVnpYr2gc6r8Q/mS7m0Qf6Ef9VinW8mKXM="
          }
        },
        {
          "source": "tz1XVJ8bZUXs7r5NV8dHvuiBhzECvLRLR3jW",
          "fee": 1272,
          "counter": 30739,
          "gasLimit": 10100,
          "storageLimit": 257,
          "kind": 108,
          "transactionOperationData": {
            "destination": "tz1XVJ8bZUXs7r5NV8dHvuiBhzECvLRLR3jW",
            "amount": 1
          }
        }
      ]
    }
  },

  // 'XTZ': {
  //   "cmd": "FA2",
  //   "isRevealed": false,
  //   "amount": "10",
  //   "tokenId": "1",
  //   "toAddress": "tz1ioz62kDw6Gm5HApeQtc1PGmN2wPBtJKUP",
  //   "senderAddress": "tz1ioz62kDw6Gm5HApeQtc1PGmN2wPBtJKUP",
  //   "destination": "KT1DYk1XDzHredJq1EyNkDindiWDqZyekXGj",
  //   "transactionAmount": 0,
  //   "source": "tz1ioz62kDw6Gm5HApeQtc1PGmN2wPBtJKUP",
  //   "fee": 100000,
  //   "counter": 2993174,
  //   "gasLimit": 100000,
  //   "storageLimit": 0,
  //   "branch": "BKvEAX9HXfJZWYfTQbR1C7B3ADoKY6a1aKVRF7qQqvc9hS8Rr3m",
  //   "reveal_fee": 100000,
  //   "reveal_counter": 2993173,
  //   "reveal_gasLimit": 100000,
  //   "reveal_storageLimit": 0,
  // },
  // 'XTZ': {
  //   "cmd": "FA12",
  //   "isRevealed": false,
  //   "branch": "BL8euoCWqNCny9AR3AKjnpi38haYMxjei1ZqNHuXMn19JSQnoWp",
  //   "transactionAmount": 0,
  //   "destination": "KT1DYk1XDzHredJq1EyNkDindiWDqZyekXGj",
  //   "senderAddress": "tz1ioz62kDw6Gm5HApeQtc1PGmN2wPBtJKUP",
  //   "toAddress": "tz1ioz62kDw6Gm5HApeQtc1PGmN2wPBtJKUP",
  //   "value": "123",
  //   "source": "tz1ioz62kDw6Gm5HApeQtc1PGmN2wPBtJKUP",
  //   "fee": 100000,
  //   "counter": 2993173,
  //   "gasLimit": 100000,
  //   "storageLimit": 0,
  //   "reveal_fee": 100000,
  //   "reveal_counter": 2993173,
  //   "reveal_gasLimit": 100000,
  //   "reveal_storageLimit": 0,
  // },
  'ETH': {
    "chainId": "0x01",
    "nonce": "0x00",
    "gasPrice": "0x07FF684650",
    "gasLimit": "0x5208",
    "toAddress": "0xC894F1dCE55358ef44D760d8B1fb3397F5b1c24b",
    "amount": "0x0DE0B6B3A7640000",
  },
  'BTC': {
    // https://blockchain.info/unspent?active=35oxCr5Edc2VjoQkX65TPzxUVGXJ7r4Uny
    // https://blockchain.info/unspent?active=bc1qxjth4cj6j2v04s07au935547qk9tzd635hkt3n
    "utxos": [
      {
        "txid":
            "fce42021fd2d2fa793dc3d5d6520fc853e327e5c2c638c3a0be7529c559d3536",
        "vout": 1,
        "value": 4500,
        "script": "001434977ae25a9298fac1feef0b1a52be058ab13751",
      },
    ],
    "toAddress": "15o5bzVX58t1NRvLchBUGuHscCs1sumr2R",
    "amount": 3000,
    "fees": 1000,
    "changeAddress": "15o5bzVX58t1NRvLchBUGuHscCs1sumr2R",
    "change": 500,
    "privateKeys": [
      "a321c4996143e0add05864bbb694ceb399fbe5d0884d721b1a04755f9f7497a9",
      "bbc27228ddcb9209d7fd6f36b02f7dfa6252af40bb2f1cbc7a557da8027ff866",
      "619c335025c7f4012e556c2a58b2506e30b8511b53ade95ea316fd8c3286feb9",
      "eae04f225475e7630e58efdbefe50a003efd7e2ade3e67e171e023e9278b6ea4"
    ]
  },
  'TRX': {
    "cmd": "TRC20", // can be TRC20 | TRX | TRC10 | CONTRACT | FREEZE
    "ownerAddress": "TYjYrDy7yE9vyJfnF5S3EfPrzfXM3eehri", // from address
    "toAddress": "TJpQNJZSktSZQgEthhBapH3zmvg3RaCbKW", // to address
    "contractAddress":
        "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t", // in case of Trc20 (Tether USDT)
    "timestamp": DateTime.now().millisecondsSinceEpoch,
    "amount":
        "000F4240", // 27 * 1000000, // "004C4B40", // "000F4240" = 1000000 sun hex 2's signed complement
    // (https://www.rapidtables.com/convert/number/hex-to-decimal.html)
    // for asset TRC20 | integer for any other in SUN, 1000000 SUN = 1 TRX
    "feeLimit": 10000000,
    // reference block data to be obtained by querying the blockchain
    "blockTime":
        1638519600000, // timestamp of block to be included milliseconds
    "txTrieRoot":
        "5807aea383e7de836af95c8b36e22654e4df33e5b92768e55fb936f8a7ae5304", // trie root of block
    "witnessAddress":
        "41e5e572797a3d479030e2596a239bd142a890a305", // address of witness that signed block
    "parentHash":
        "0000000002254183f6d15ba4115b3a5e8a8359adc663f7e6f02fa2bd51c07055", // parent hash of block
    "version": 23, // block version
    "number": 35996036, // block number
    // freezing
    "frozenDuration": 3, // frozen duration
    "frozenBalance": 10000000, // frozen balance in SUN
    "resource": "ENERGY", // Resource type: BANDWIDTH | ENERGY
    "assetName": "ALLOW_SAME_TOKEN_NAME"
  },
  'SOL': {
    // return {
    //   "recentBlockhash": "C6oRG8fykBeM7sL5eYyqRSZp9m2QdkGHQqtE8nTszURZ",
    //   "transferTransaction": {"recipient": "CiFADrjcd1acfVqg7hU1jpbNsdNkiUAexY9mRutsQUoR", "value": "250000"}
    // };
    "recentBlockhash": "EjUjs69fQ7JG1aHwrzMET2YqTe6PMMbtbHvCEtzvDZsJ",
    "tokenTransferTransaction": {
      "tokenMintAddress": "Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB",
      "senderTokenAddress": "7LKVpn2ZP9L7PkyFGApri9xEqUv4N8U8QCRyMHrCZqju",
      "recipientTokenAddress": "88mvV5z4gvbn7ZXcKvnCDJuoUaALis54auijidhjTbJT",
      "amount": "200000",
      "decimals": "6"
    }
  },
  'NEAR': {
    'signerID':
        '434c894cacb459ca4eeadefc7e9868c2eb68b33c0ba81f8434f2bb435b4bbb7b', // (account ID of the transaction originator)
    'receiverID':
        '434c894cacb459ca4eeadefc7e9868c2eb68b33c0ba81f8434f2bb435b4bbb7b', // (account ID of the transaction recipient)
    'nonce': 1, // (increments for every new tx)
    'amount':
        '01000000000000000000000000000000', // // uint128_t / little endian byte order
    'blockHash': '244ZQ9cgj3CQ6bWBdytfrJMuMQ1jdXLFGnr4HhvtCTnM', //
  },
  // 'XLM': {
  //   "cmd": 'Payment',
  //   "ownerAddress": "GCHYGAVOESDOZONH2UDWHTTEF3FQIZSQFBSMK3ZJ5Z5QS37TXNPN2LWI",
  //   "toAddress": "GBPT3GVKY727GYXTO6QAEVET3AW3EUVZZCZOCCO5B5PJXRVS3S4GD2AY",
  //   "asset": "USDT",
  //   "amount": 900000,
  //   "fee": 10000,
  //   "sequence": 184158241918287877,
  // },
  'XLM': {
    "cmd": 'Payment',
    "ownerAddress": "GCPP3J7CE23VF3EONOIDXDL6QODYTI3YWJ7PNMHTO77WSEXGK2TT4QPV",
    "toAddress": "GBPT3GVKY727GYXTO6QAEVET3AW3EUVZZCZOCCO5B5PJXRVS3S4GD2AY",
    "issuer": "GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5",
    "network": "testnet",
    "validBefore": 1717806538278,
    "amount": 2000000,
    "fee": 10000,
    "sequence": 183629192141733925,
    "asset": "USDC",
    "memo": "3476840067250060816"
  },
  // 'XLM': {
  //   "cmd": "ChangeTrust",
  //   "ownerAddress":
  //       "GBPT3GVKY727GYXTO6QAEVET3AW3EUVZZCZOCCO5B5PJXRVS3S4GD2AY", //
  //   "toAddress": "GCHYGAVOESDOZONH2UDWHTTEF3FQIZSQFBSMK3ZJ5Z5QS37TXNPN2LWI", //
  //   "assetCode": "USDT",
  //   "validBefore": 1695723258,
  //   "fee": 10000,
  //   "sequence": 184070843628781573
  // }
  'BNB': {
    "chainID": "Binance-Chain-Tigris",
    "accountNumber": 7321705,
    "sequence": 6,
    "source": 0,
    "memo": "532127419",
    "fromAddress": "bnb19fy0e8m8zwqa3wn7dly7lyp9vl6ealhg4hkvtw",
    "toAddress": "bnb136ns6lfw4zs5hg4n85vdthaad7hq5m4gtkgf23",
    "amount": 10000,
  },
  // 'ETH': {
  //   "chainId": "0x38",
  //   "nonce": "0x05",
  //   "gasPrice": "0x012a05f200",
  //   "gasLimit": "0x5208",
  //   "toAddress": "0xAca4830231E74a9087EFB56a0561f8e1D87776e8",
  //   "amount": "0x00de0b6b3a7640",
  // },
  'DOGE': {
    "utxos": [
      {
        "txid":
            "ec6cc99e0084361ada185f059d53ad4db12d2a716299dcb3f74e6dfdd87cc2cb",
        "vout": 1,
        "value": 2840100000,
      },
    ],
    "toAddress": "DBVdaWiPdsHxMrfQynRtCe9yEXomxM2Xui",
    "amount": 300000,
    "fees": 5000,
    "changeAddress": "D9pvhnWknRza2HTXhY5WT29D4kvYzTZQAF",
  },
  // 'ETH': {
  //   "chainId": "0x89",
  //   "nonce": "0x00",
  //   "gasPrice": "0x07FF684650",
  //   "gasLimit": "0x5208",
  //   "toAddress": "0xC894F1dCE55358ef44D760d8B1fb3397F5b1c24b",
  //   "amount": "0x0DE0B6B3A7640000",
  // },
  //............Polygon USDC test........
  // 'ETH': {
  //   "cmd": "ERC20",
  //   "chainId": "0x89",
  //   "nonce": "0x00",
  //   "gasPrice": "0x07FF684650",
  //   "gasLimit": "0x5208",
  //   "toAddress": "0xC894F1dCE55358ef44D760d8B1fb3397F5b1c24b",
  //   "amount": "0x0DE0B6B3A7640000",
  //   "contractAddress": "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174"
  // },

  //............Polygon USDT test........
  // 'ETH': {
  //   "cmd": "ERC20",
  //   "chainId": "0x89",
  //   "nonce": "0x00",
  //   "gasPrice": "0x07FF684650",
  //   "gasLimit": "0x5208",
  //   "toAddress": "0xC894F1dCE55358ef44D760d8B1fb3397F5b1c24b",
  //   "amount": "0x0DE0B6B3A7640000",
  //   "contractAddress": "0xc2132D05D31c914a87C6611C10748AEb04B58e8F"
  // },
  'ADA': {
    "senderAddress":
        "addr1q9evp7aqelh4epkacgyeqweqgkvqsl8gdp54mxew5kdvuyhqhuqa6ngy0jrdcnknurcvjgtv4jd84pd7xllgmdz0wtrqgfz5l4",
    "receiverAddress":
        "addr1qyk022rpw85g7c0f0wuq6zpkakgjwsftmpd99wqjj4xcsjc74pfgs7t76yuehca7hn4pcl37lsl06ccey0epe5sp4lwslxsyrw",
    "amount": 40000,
    "ttl": 53333333,
    "utxos": [
      {
        "senderAddress":
            "addr1q9evp7aqelh4epkacgyeqweqgkvqsl8gdp54mxew5kdvuyhqhuqa6ngy0jrdcnknurcvjgtv4jd84pd7xllgmdz0wtrqgfz5l4",
        "txid":
            "76608917328b3768b3985d057e613c7e8f14cb1f27b132a750a363ee64363a57",
        "index": 0,
        "balance": 16900000,
      },
    ],
  }
};

// ignore: inference_failure_on_function_return_type
runOperations() async {
  // Platform messages may fail, so we use a try/catch PlatformException.
  // We also handle the message potentially returning null.
  try {
    String mnemonic = await Trustdart.generateMnemonic();
    print('Here is our mnemonic: \n$mnemonic');

    String dondo =
        "imitate embody law mammal exotic transfer roof hope price swift ordinary uncle";
    // dondo = "a d f d s e w q t y u l";
    bool wallet = await Trustdart.checkMnemonic(dondo);
    print(wallet);
    // https://github.com/satoshilabs/slips/blob/master/slip-0044.md
    String dataToSign =
        "03f5a22ee15cd6434751ea528328dd071738e1cfb39fb3c60d306528ff6f46b6e06c00bf43035fb548c011acf2efc84106075b8aa100038827bafcd916904ede02e80701a15985af2de2c555defbac9b8675efd9563285d400ffff07636f6c6c65637400000004008ea010";

    for (Coin coin in coinList) {
      print('Check for ${coin.code} on path ${coin.path} ...');
      print('=======================================================');
      String privKey = await Trustdart.getPrivateKey(
        dondo,
        coin.code,
        coin.path,
      );
      print('Private Key Check ...');
      print([
        privKey,
      ]);

      Uint8List rawPrivKey = await Trustdart.getRawPrivateKey(
        dondo,
        coin.code,
        coin.path,
      );
      print('Raw Private Key Check ...');
      print([
        rawPrivKey,
      ]);

      String pubKey = await Trustdart.getPublicKey(
        dondo,
        coin.code,
        coin.path,
      );
      print('Publick Key Check ...');
      print([pubKey]);

      Uint8List rawPubKey = await Trustdart.getRawPublicKey(
        dondo,
        coin.code,
        coin.path,
      );
      print('Raw Publick Key Check ...');
      // ignore: avoid_print
      print([
        rawPubKey,
      ]);

      Map address = await Trustdart.generateAddress(
        dondo,
        coin.code,
        coin.path,
      );
      print('Address Check ...');
      print([
        address,
      ]);

      Uint8List seed = await Trustdart.getSeed(
        dondo,
        coin.code,
        coin.path,
      );
      print('Seed Check ...');
      print([
        seed,
      ]);

      bool valid = await Trustdart.validateAddress(
        coin.code,
        address['legacy']!,
      );
      print([valid]);

      bool invalid = await Trustdart.validateAddress(
        coin.code,
        address['legacy']! + '0',
      );
      print('Invalid Check ...');
      print(coin.code);
      print([invalid]);

      String tx = await Trustdart.signTransaction(
        dondo,
        coin.code,
        coin.path,
        operations[coin.code],
      );
      print('Transaction Check ...');
      print([tx]);

      print(operations[coin.code]["privateKeys"]);
      String multiTxSign = await Trustdart.multiSignTransaction(coin.code,
          operations[coin.code], operations[coin.code]["privateKeys"]);
      print('MultiSig Transaction Check ...');
      print([multiTxSign]);

      String signedData = (await Trustdart.signDataWithPrivateKey(
        dondo,
        coin.code,
        coin.path,
        dataToSign,
      ));
      print('Sign Data with Priv Key Check ...');
      print(signedData);
      print('');
    }
  } catch (e) {
    print(e);
  }
}
