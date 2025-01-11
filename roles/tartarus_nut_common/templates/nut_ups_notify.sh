#!/bin/bash

# This script is called by NUT when an event occurs.
# https://networkupstools.org/docs/user-manual.chunked/ar01s07.html

set -eu 

# Apprise is installed in opt/apprise by the tartarus_apprise role
source /opt/apprise/bin/activate

signalReceived=$1
eventType="${NOTIFYTYPE}"

baseMessage="
=== UPS Event ===
UPS Name: ${UPSNAME}
Host: $(hostname)
Event Type: ${eventType}
ArgV[1]: $signalReceived
"

case $signalReceived in
    onbattwarn)
        batteryRuntimeSeconds=$(upsc tripplite-2018@augustus.tartarus.us | grep battery.runtime | awk -F':' '{print $2}' | tr -d '[:space:]')
        batteryRuntime=$(printf '%02dh:%02dm:%02ds\n' $((batteryRuntimeSeconds/3600)) $((batteryRuntimeSeconds%3600/60)) $((batteryRuntimeSeconds%60)))
        message="
        ${UPSNAME} is running on battery power. 
        Estimated runtime: ${batteryRuntime}.
        
        ${baseMessage}
        Handled by: onbattwarn
        "
        apprise --title=":battery: UPS Event: ${UPSNAME}" --body="${message}" --tag=alert --notification-type=warning --interpret-emojis
        ;;
    onbattshutdown)
        batteryRuntimeSeconds=$(upsc tripplite-2018@augustus.tartarus.us | grep battery.runtime | awk -F':' '{print $2}' | tr -d '[:space:]')
        batteryRuntime=$(printf '%02dh:%02dm:%02ds\n' $((batteryRuntimeSeconds/3600)) $((batteryRuntimeSeconds%3600/60)) $((batteryRuntimeSeconds%60)))
        message="
        Triggering FSD for \"${UPSNAME}\" after running on battery power for >2 minutes. 
        Estimated remaining runtime: ${batteryRuntime}.
        
        ${baseMessage}
        Handled by: onbattshutdown
        "
        /sbin/upsmon -c fsd
        apprise --title=":battery::arrow_right::headstone: UPS Event: ${UPSNAME}" --body="${message}" --tag=alert --notification-type=warning --interpret-emojis
        ;;
    ups-back-on-power)
        message="
        ${baseMessage}
        Handled by: ups-back-on-power
        "
        apprise --title=":electric_plug: UPS Event: ${UPSNAME}" --body="${message}" --tag=alert --notification-type=success --interpret-emojis
        ;;
    fsd)
        message="
        ${baseMessage}
        Handled by: fsd
        "
        apprise --title=":headstone: UPS Event: ${UPSNAME}" --body="${message}" --tag=alert --notification-type=success --interpret-emojis
        ;;
    shutdown)
        message="
        ${baseMessage}
        Handled by: shutdown
        "
        apprise --title=":skull: UPS Event: ${UPSNAME}" --body="${message}" --tag=alert --notification-type=success --interpret-emojis
        ;;
    commbad)
        message="
        ${baseMessage}
        Handled by: commbad
        "
        apprise --title=":x: UPS Event: ${UPSNAME}" --body="${message}" --tag=alert --notification-type=success --interpret-emojis
        ;;
    commok)
        message="
        ${baseMessage}
        Handled by: commok
        "
        apprise --title=":white_check_mark: UPS Event: ${UPSNAME}" --body="${message}" --tag=alert --notification-type=success --interpret-emojis
        ;;
    nocomm)
        message="
        ${baseMessage}
        Handled by: nocomm
        "
        apprise --title=":x: UPS Event: ${UPSNAME}" --body="${message}" --tag=alert --notification-type=success --interpret-emojis
        ;;
    lowbatt)
        message="
        ${baseMessage}
        Handled by: lowbatt
        "
        apprise --title=":low_battery: UPS Event: ${UPSNAME}" --body="${message}" --tag=alert --notification-type=warning --interpret-emojis
        ;;
    replbatt)
        message="
        ${baseMessage}
        Handled by: replbatt
        "
        apprise --title=":wrench: UPS Event: ${UPSNAME}" --body="${message}" --tag=alert --notification-type=warning --interpret-emojis
        ;;
    noparent)
        message="
        ${baseMessage}
        Handled by: noparent
        "
        apprise --title=":angel: UPS Event: ${UPSNAME}" --body="${message}" --tag=alert --notification-type=info --interpret-emojis
        ;;
    *)
        message="
        ${baseMessage}
        Handled by: generic handler
        "
        apprise --title=":question: UPS Event: ${UPSNAME}" --body="${message}" --tag=alert --notification-type=info --interpret-emojis
        ;;
esac