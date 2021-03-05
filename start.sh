#!/bin/bash
export SECRET_KEY_BASE=W68eso5YQOlbtvSNUR50N/HDWj6IaEhAwMR3LtzuBEQAefwYVbX84bvoTA7XtiGi
export MIX_ENV=prod
export PORT=4795

echo "Stopping old copy..."
/home/trevor/www/events.downwind.xyz/eventApp/_build/prod/rel/eventapp/bin/eventapp stop || true

# /home/hw06/hw06/_build/prod/rel/bulls_hw06/bin/bulls_hw06 stop || true

echo "Starting app..."

/home/trevor/www/events.downwind.xyz/eventApp/_build/prod/rel/eventapp/bin/eventapp start

# /home/hw06/hw06/_build/prod/rel/bulls_hw06/bin/bulls_hw06 start
