{
  description = "simple static homepage generator";

  inputs.colors.url = "github:sotormd/colors";

  outputs =
    { colors, ... }:
    let
      c = colors.lib.colors;

      makeHomepage =
        {
          layout,
          n ? 5,
          font ? "IBM Plex Sans",
        }:
        let
          renderColumn = links: ''
            <div class="column">
              ${builtins.concatStringsSep "\n" (
                map (
                  l:
                  ''<a href="${l.url}" class="link" data-short="/${l.short}/" data-full="${l.full}">/${l.short}/</a>''
                ) links
              )}
            </div>
          '';

          layoutHTML = builtins.concatStringsSep "\n" (
            map (item: if builtins.isString item then ''<hr class="separator">'' else renderColumn item) layout
          );
        in
        ''
          <!DOCTYPE html>
          <html lang="en">
          <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>home</title>
            <style>
              body {
                background-color: #${c.bg0};
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                height: 100vh;
                font-family: ${font};
                font-size: 18px;
                margin: 0;
              }

              .column {
                display: grid;
                grid-template-columns: repeat(${toString n}, 1fr);
                gap: 10px;
                margin: 10px 0;
              }

              .separator {
                width: calc(${toString n} * 144px + (${toString n} - 1) * 10px);
                border: 2px solid #${c.blue2};
                margin: 10px 0;
              }

              .link {
                text-align: center;
                padding: 20px 17px;
                color: #${c.fg0};
                text-decoration: none;
                border-radius: 5px;
                background-color: #${c.bg3};
                transition: background-color 0.3s ease;
                min-width: 110px;
              }

              .link:hover {
                background-color: var(--random-color);
                color: #${c.bg0};
              }
            </style>
          </head>
          <body>
            ${layoutHTML}
            <script>
              function getRandomColor() {
                const colors = ["#${c.red}", "#${c.orange}", "#${c.yellow}", "#${c.green}", "#${c.purple}"];
                return colors[Math.floor(Math.random() * colors.length)];
              }

              document.querySelectorAll('.link').forEach(link => {
                link.addEventListener('mouseover', () => {
                  link.style.backgroundColor = getRandomColor();
                  link.textContent = link.dataset.full;
                });
                link.addEventListener('mouseout', () => {
                  link.style.backgroundColor = "";
                  link.textContent = link.dataset.short;
                });
              });

              // keyboard shortcuts
              let keyBuffer = "";
              const links = document.querySelectorAll('.link');
              document.addEventListener('keydown', (e) => {
                keyBuffer += e.key.toLowerCase();
                for (const link of links) {
                  if (link.dataset.short.replace(/\//g, "") === keyBuffer) {
                    window.location = link.href;
                    return;
                  }
                }
                if (keyBuffer.length > 2) keyBuffer = "";
              });
            </script>
          </body>
          </html>
        '';

      # Example homepage layout
      exampleLayout = [
        "separator"

        [
          {
            short = "op";
            full = "spotify";
            url = "https://open.spotify.com";
          }
          {
            short = "yt";
            full = "youtube";
            url = "https://youtube.com";
          }
          {
            short = "ig";
            full = "instagram";
            url = "https://instagram.com";
          }
          {
            short = "dc";
            full = "discord";
            url = "https://discord.com/channels/@me";
          }
          {
            short = "li";
            full = "lichess";
            url = "https://lichess.org";
          }
          {
            short = "fm";
            full = "lastfm";
            url = "https://last.fm";
          }
          {
            short = "gh";
            full = "github";
            url = "https://github.com";
          }
          {
            short = "mt";
            full = "monkeytype";
            url = "https://monkeytype.com";
          }
          {
            short = "wk";
            full = "wikipedia";
            url = "https://en.wikipedia.org/wiki/Main_Page";
          }
          {
            short = "ch";
            full = "chatgpt";
            url = "https://chatgpt.com";
          }
          {
            short = "np";
            full = "nix packages";
            url = "https://search.nixos.org/packages?channel=unstable";
          }
          {
            short = "no";
            full = "nix options";
            url = "https://search.nixos.org/options?channel=unstable";
          }
          {
            short = "hm";
            full = "hm options";
            url = "https://home-manager-options.extranix.com/release=master";
          }
          {
            short = "nw";
            full = "nixos wiki";
            url = "https://wiki.nixos.org/wiki/NixOS_Wiki";
          }
          {
            short = "aw";
            full = "arch wiki";
            url = "https://wiki.archlinux.org/title/Main_page";
          }
        ]

        "separator"
      ];

      exampleHtml = makeHomepage {
        layout = exampleLayout;
        n = 5;
        font = "'IBM Plex Sans'";
      };

    in
    {
      lib.makeHomepage = makeHomepage;
      packages.x86_64-linux.default = builtins.toFile "homepage.html" exampleHtml;
    };
}
