Animoto API Client
==================

## Pseudocode Workflow

	require 'animoto/client'
	include Animoto
	
	client = Client.new("username", "password")

	project = Project.new("Amazing Title!", :producer => "Fishy Joe")
	project << Image.new("http://website.com/picture.png")
	project << Image.new("http://website.com/hooray.png", :spotlight => true)
	project << TitleCard.new("Woohoo!", "Hooray for everything!")
	project << Footage.new("http://website.com/movie.mp4", :duration => 3.5)
	project << Song.new("http://website.com/song.mp3", :artist => "Fishy Joe")

	directing_job = client.direct!(project)
	sleep(30) while directing_job.pending?

	if storyboard = directing_job.storyboard
		rendering_job = client.render!(storyboard, :resolution => "720p")
		sleep(30) while rendering_job.pending?

		if video = rendering_job.video
			puts video.url
		else
			raise rendering_job.errors.first
		end
	else
		raise directing_job.errors.first
	end