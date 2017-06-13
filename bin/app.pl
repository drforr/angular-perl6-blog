use v6;
use Bailador;
use Bailador::Route::StaticFile;
Bailador::import();

my $version = '0.01';

class AngularWebSockets is Bailador::App {

	# Bypass the template handler and simply return the file contents.
	method static-file( $name ) {
		my $rootdir = $?FILE.IO.parent.parent;
		my $file = ($rootdir ~ '/' ~ $name).IO.slurp;
		return $file;
	}

	submethod BUILD(|) {
		self.get: '/styles.css' => sub {
			header('Content-Type', 'text/css');
			self.static-file: 'src/styles.css';
		};

		# Welcome to the single-page site - /dashboard, /heroes and / all share the
		# same template page.
		#
		self.get: '/dashboard' => sub {
			self.static-file: 'src/index.html';
		};
		self.get: '/heroes' => sub {
			self.static-file: 'src/index.html';
		};
		self.get: '/' => sub {
			self.static-file: 'src/index.html';
		};


		# Yes, this is (almost) a catch-all route.
		# Most of the 'when' clauses can be factored out, but this way I have complete
		# control of what gets displayed over what route. And until Bailador properly
		# logs 404s this is the simplest way to catch them.
		#
		self.get: / ( .+ ) / => sub ($route) {
			my $stripped-route = $route.substr(1);
			given $route {
				when '/main.js' |
				 		'/systemjs-angular-loader.js' |
						'/systemjs.config.js' |
						m{ '/app' }
				{
					self.static-file: 'src/' ~ $stripped-route;
				}
				when m{ '/node_modules' } {
					if $stripped-route.IO.e {
						self.static-file: $stripped-route;
					}
					else {
						warn "404 no file $stripped-route found";
					}
				}
				default {
					warn "404 could not find '$route'";
				}
			}
		}

		#`( How to distinguish XHR from non-XHR requests, apparently not necessary
		    but I'll leave this code here for the time being.
		my $rootdir = $?FILE.IO.parent.parent;

		self.get: / '/' ( .+ ) / => sub ($route) {
			my $req = request();
			if $req.headers.<ACCEPT> and $req.headers.<ACCEPT> ~~ / 'x-es-module' / {
				warn "Caught XHR request";
				self.template: '../src/' ~ $route;
			}
			else {
				self.template: '../src/' ~ $route;
			}
		};
		)
	}
}

my $app = AngularWebSockets.new;

app $app;

baile;
