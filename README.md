# For Pupper Eyes Only

Okay so I think I've successfully put my entire development environment into Docker lol. I didn't want you to have to install a ton of shit just to be able to run my server code, so everything *should* just work as long as you install Docker. I've never tried it on Windoodoos tho.

Once you pull the code down and install Docker, it *should* be as simple as typing `docker compose build` followed by `docker compose up` in the terminal inside vscode. You'll only have to do the build command the first time. It basically will grab my dev stuff and shove them into docker images you don't have to worry about. The second command will actually run the code. The first time it runs, it will take a while to start up because it has to compile all the dependencies the framework I'm using uses. Shouldn't take that long on later builds tho.

Once it's running, just go to your browser and put `localhost` into the url bar. You should see the Phoenix template site. And the great part is that it has live reloading. So anything you change in the css or anything should just automatically show up in the browser as long as the server is running. Cool shit.

Anyway uhhhhhhh lemme know if Windoodoos makes life pain.
