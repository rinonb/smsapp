# README

### Why use a storage layer?
There's the possibility that while sending messages, especially multi part messages, there could be failures, such as connectivity issues, sms provider unavailability, etc. Having the data stored in the database would make it possible to add a retry mechanism.

### What's missing?
Among other things, there's no serializer and not handling bad responses from sms provider. I did not implement these as I didn't want to spend more than 2 hours working on this actively.
