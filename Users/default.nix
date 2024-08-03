{ jovian
, mkSystem
, ...
}:

{
 Vanilla = mkSystem "/Vanilla"
                    []
                    [];

 SteamDeck = mkSystem "/SteamDeck"
                      [
                       jovian.nixosModules.jovian
                      ]
                      [
                       jovian.overlays.default
                      ];
}
