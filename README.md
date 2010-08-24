Animoto API Ruby Client
=======================

The Animoto API is a RESTful web service that transforms images, videos,
music, and text into amazing video presentations.

The Animoto API Ruby Client provides a convenient Ruby interface for working
with the Animoto RESTful HTTP API.

### Topics

  * [Who should read this document](#who_should_read_this_document)
  * [What is covered in this document](#what_is_covered_in_this_document)
  * [Getting Started using the Ruby Client](#getting_started_using_the_ruby_client)
  * [How to contribute to this client](#how_to_contribute)

<a name="who_should_read_this_document"></a>
## Who should read this document?

This document is primarily aimed at developers looking to integrate with
Animoto services from a Ruby environment or using the Ruby language.

<a name="what_is_covered_in_this_document"></a>
## What is covered in this document

This document covers the technical details of the Animoto API Ruby client and 
provides a general overview of its use.

This document does not cover the details of the Animoto API itself. For such information please see the [Animoto API documentation][api_docs]

<a name="getting_started_using_the_ruby_client"></a>
## Getting Started using the Ruby Client

### Prerequisites

#### Readers of this document should be familiar with...

  * The [the Ruby language](http://ruby-lang.org)
  * The [Animoto API documentation][api_docs]

#### Authentication

You must have a application key and secret to use the Animoto API. If you
don't have a key/secret pair, please contact your Animoto representative. Note
that you may have multiple key/secret pairs at one time.

### Conceptual overview of Animoto

Creating a video using the Animoto API consists of two major steps:
"directing" and "rendering".

Directing is the process in which the Animoto system analyzes input visuals
and music and determines the best way to present those visuals with the
specified music. The output of directing is stored in the Animoto system for
later use and is called a "storyboard".

The second major phase of creating an Animoto video is called rendering.
Rendering is the transformation of the artistic choices made by the director
(and stored in a storyboard) into an actual video file that can be downloaded
and viewed.

Every time a new set of photos is to be transformed into a video, or every
time a new set of artistic choices is to be made, a new storyboard must be
created via directing. Once directing happens and a storyboard is created,
videos can be rendered from that storyboard at any time, each with a different
resolutions, encodings, etc suitable to different display environments.

While directing and rendering are generally speedy processes, they do take
longer than is appropriate for a typical HTTP request. These long-running
tasks are represented as "jobs" in the Animoto API. Directing (creating
storyboards) is accomplished by initiating a directing job, and rendering
(creating a video file) starts by creating a rendering job. Jobs are a handy
way to track status and debug problems if the requested operation couldn't be
completed.

### Creating a video using the Ruby client

This example shows how to create an Animoto video in one shot with the Ruby
client and using HTTP callbacks for status updates.

    require 'animoto/client'
    include Animoto

    # Create a new client using our application key and secret
    client = Client.new("application_key", "secret")

    # create a directing and rendering manifest with the video title and 
    # producer.  Also include rendering parameters like resolution, framerate,
    # and format.
    manifest = DirectingAndRenderingManifest.new(
      :title => "Amazing Title!", 
      :producer => "Fishy Joe", 
      :resolution => "720p", 
      :framerate => 24, 
      :format => 'h264'
    )
    
    # Add some images, text, and footage to our manifest.
    manifest << Image.new("http://website.com/picture.png")
    manifest << Image.new("http://website.com/hooray.png", :spotlit => true)
    manifest << TitleCard.new("Woohoo!", "Hooray for everything!")
    manifest << Footage.new("http://website.com/movie.mp4", :duration => 3.5)
    
    # Setup the soundtrack.
    manifest << Song.new("http://website.com/song.mp3", :artist => "Fishy Joe")
    
    # Setup to get http callbacks for status notification (see below for 
    # polling example).
    manifest.http_callback_url = "http://mysite.com/animoto_callback"
    manifest.http_callback_format = "json"

    # Send the manifest to the API.  Your app will be notified of 
    # completion/failure via an HTTP POST to 
    # "http://mysite.com/animoto_callback"
    client.direct_and_render!(manifest)


### A basic example using the Ruby client

This example shows how to separately direct a storyboard and render a video
with that storyboard. It also demonstrates how to use polling to check on job
status.

    require 'animoto/client'
    include Animoto

    # Create a new client using our application key and secret
    client = Client.new("application_key", "secret")

    # Create a directing manifest.  The directing manifest controls the images
    # and other visual elements that will be in our final video.
    manifest = DirectingManifest.new(:title => "Amazing Title!", :producer => "Fishy Joe")
    
    # Add some images, text, and footage to our manifest.
    manifest << Image.new("http://website.com/picture.png")
    manifest << Image.new("http://website.com/hooray.png", :spotlit => true)
    manifest << TitleCard.new("Woohoo!", "Hooray for everything!")
    manifest << Footage.new("http://website.com/movie.mp4", :duration => 3.5)
    
    # Setup the soundtrack.
    manifest << Song.new("http://website.com/song.mp3", :artist => "Fishy Joe")

    # Request a new directing job by sending the API our directing manifest.
    directing_job = client.direct!(manifest)
    
    # Poll the service until the directing job is done.
    while directing_job.pending?
    	sleep(30)
    	client.reload!(directing_job)
    end

    # If the directing job finished successfully, there will be a "storyboard" 
    # associated with this job.
    if storyboard = directing_job.storyboard
    
      # Now it's time to render the storyboard into a video.  First we create
      # a rendering manifest.
    	manifest = RenderingManifest.new(storyboard, :resolution => "720p", :framerate => 24, :format => 'h264')
    	
    	# Send the manifest to the API.
    	rendering_job = client.render!(manifest)
    	
    	# Poll the service until the rendering job is done
    	while rendering_job.pending?
    		sleep(30)
    		client.reload!(rendering_job)
    	end

      # If the job has a video associated with it, everything worked out ok.
    	if video = rendering_job.video
    	  # Print a link to download the video file.
    		puts video.url
    	else
    	  # Something happened during rendering...
    		raise rendering_job.errors.first
    	end
    else
      # Looks like there was a problem. Perhaps one of the assets wasn't 
      # retrieved or was corrupt...
    	raise directing_job.errors.first
    end

<a name="how_to_contribute"></a>
## How to contribute to this client

1. [Fork](http://help.github.com/forking/) `animoto_ruby_client`
2. Create a topic branch - `git checkout -b my_branch`
3. Push to your branch - `git push origin my_branch`
4. Create an [Issue](http://github.com/animoto/animoto_ruby_client/issues) with a link to your branch
5. That's it!

You might want to checkout our [the wiki page](http://wiki.github.com/animoto/animoto_ruby_client) for information
on coding standards, new features, etc.


[api_docs]: http://animoto.com/developer/api
