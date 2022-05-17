location = "logs/default"

function set_log_location(new_location)
 location = new_location
end

function log(text, overwrite)
 printh(text, location, overwrite)
end