# Automated Weather Satellite Ground Station

This project allows you to create a fully automated ground station that will receive and decode NOAA weather satellite images and upload them to your own web server.
For full details of the project, see the [full project writeup on the Project Lab blog](https://nootropicdesign.com/projectlab/2019/11/08/weather-satellite-ground-station/).

The scripting in this project is largely based on the excellent work by [Jim Haslett](https://www.youtube.com/user/JimHaslett) as described in his well-written Instructable, [Raspberry Pi NOAA Weather Satellite Receiver](https://www.instructables.com/id/Raspberry-Pi-NOAA-Weather-Satellite-Receiver/).

## Additional Dependencies
Most dependencies are already described in the instructable above.
The following are additionally needed:
- libxft2 (required by WxToImg but not mentioned in the instructable)
- parallel

## Explanation of the files:
### config.env
all configuration settings go in this file. see `config.example.env` for details.

### configure.sh
This is used for the one-time-setup. This adds `schedule_all.sh` to the current users' crontab to run at 0:00 daily.

### schedule_all.sh
This removes all `at` jobs, deletes `upcoming_passes.txt` and runs `schedule_satellite.sh` for each satellite.

### schedule_satellite.sh
This uses `predict` to get all passes of one satellite for today and tomorrow and adds an `at` job into the queue to run `receive_and_process_satellite.sh` at the correct time.

### receive_and_process_satellite.sh
This starts and stops the sdr capture, converts the file to wav and (if the capture was successful, which it might not be if passes overlap or something is wrong with the rtl-sdr) runs `process_satellite.sh` and `upload.sh`.

### process_satellite.sh
This runs `wxmap` to get the map overlay and then `wxtoimg` with several enhancement types. This also outputs the passed parameters so you can re-run processing if something goes wrong. Be aware, wxtoimg uses the audio files' create/modify date to put the map overlay in the right place on the image.

### upload.sh
This uploads the `upcoming_passes.txt`, audio files, image files and meta files to a WebDAV share.

Directory structure:
- / (the configured WebDAV data directory)
    - upcoming_passes.txt
    - meta/
        - 2020/
            - 04/
                - 20200407-195220-NOAA18.txt
    - images/
        - 2020/
            - 04/
                - 20200407-195220-NOAA18-RAW.png
                - 20200407-195220-NOAA18-ZA.png
                - 20200407-195220-NOAA18-NO.png
                - 20200407-195220-NOAA18-MSA.png
                - 20200407-195220-NOAA18-MCIR.png
                - 20200407-195220-NOAA18-THERM.png
