module Muzak
  module Cmd
    def _playlists_loaded?
      !!@playlists
    end

    def list_playlists(*args)
      Playlist.playlist_names.each do |playlist|
        info playlist
      end
    end

    def playlists_load(*args)
      # fail_arity(args, 1)
      # pname = args.shift
      @playlists = {}
      @playlists.default_proc = proc { |h, k| h[k] = Playlist.new(k) }

      Playlist.playlist_names.each do |pname|
        debug "loading playlist '#{pname}'"
        @playlists[pname] = Playlist.new(pname)
      end

      event :playlists_loaded, @playlist
    end

    def playlist_delete(*args)
      fail_arity(args, 1)
      pname = args.shift

      debug "deleting playist '#{pname}'"

      Playlist.delete!(pname)
      @playlist[pname] = nil
    end

    def enqueue_playlist(*args)
      return unless _playlists_loaded?
      fail_arity(args, 1)
      pname = args.shift

      @player.enqueue_playlist(@playlists[pname])
      event :playlist_enqueued, @playlists[pname]
    end

    def playlist_add_album(*args)
      return unless _playlists_loaded?

      pname = args.shift
      return if pname.nil?

      album_name = args.join(" ")
      return if album_name.nil?

      album = @index.albums[album_name]
      return if album.nil?

      @playlists[pname].add(album.songs)
    end

    def playlist_add_artist(*args)
      return unless _playlists_loaded?

      pname = args.shift
      return if pname.nil?

      artist = args.join(" ")
      return if artist.nil?

      @playlists[pname].add(@index.songs_by(artist))
    end

    def playlist_add_current(*args)
      return unless @player.running? && _playlists_loaded?

      pname = args.shift
      return if pname.nil?

      @playlists[pname].add @player.now_playing
    end

    def playlist_del_current(*args)
      return unless @player.running? && _playlists_loaded?

      pname = args.shift
      return if pname.nil?

      @playlists[pname].delete @player.now_playing
    end

    def playlist_shuffle(*args)
      return unless _playlists_loaded?

      pname = args.shift
      return if pname.nil?

      @playlists[pname].shuffle!
    end
  end
end
