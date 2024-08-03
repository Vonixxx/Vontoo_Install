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
                       jovian.overlays.default
                      ]
                      [
                       jovian.nixosModules.jovian
                      ];
}
