workers Integer(ENV['PUMA_WORKERS'] || 2)
threads Integer(ENV['PUMA_MIN_THREADS']  || 4), Integer(ENV['PUMA_MAX_THREADS'] || 16)

preload_app!

port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'
