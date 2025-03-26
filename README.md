# CairoExample
Demonstration of an snforge issue with cross contract calls. This repos contains two contracts a token and vault. The token uses the cairo open zeppelin ownable library to whitelist minting and burning. The vault calls the token to mint tokens for a user in the deposit function. In the test the token is deployed then ownership is transferred to the vault. It is asserted that the vault address is owner of the token. Calling the vault deposit function still fails with a 'Caller is not the owner' error. 
The cross contract call context for the mint function seems to be the caller not the vault. This is demonstrated in test2 which passes even though ownership is not transferred.
