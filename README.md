Animoto API Client
==================

## Workflow

	require 'animoto/client'
	include Animoto
	
	client = Client.new("username", "password")

	manifest = DirectingManifest.new(:title => "Amazing Title!", :producer => "Fishy Joe")
	manifest << Image.new("http://website.com/picture.png")
	manifest << Image.new("http://website.com/hooray.png", :spotlit => true)
	manifest << TitleCard.new("Woohoo!", "Hooray for everything!")
	manifest << Footage.new("http://website.com/movie.mp4", :duration => 3.5)
	manifest << Song.new("http://website.com/song.mp3", :artist => "Fishy Joe")

	directing_job = client.direct!(manifest)
	while directing_job.pending?
		sleep(30)
		client.reload!(directing_job)
	end

	if storyboard = directing_job.storyboard
		manifest = RenderingManifest.new(storyboard, :resolution => "720p", :framerate => 24, :format => 'h264')
		rendering_job = client.render!(manifest)
		while rendering_job.pending?
			sleep(30)
			client.reload!(rendering_job)
		end

		if video = rendering_job.video
			puts video.url
		else
			raise rendering_job.errors.first
		end
	else
		raise directing_job.errors.first
	end