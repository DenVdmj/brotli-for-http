
chrome.webRequest.onBeforeSendHeaders.addListener(details => {
  let headers = details.requestHeaders;
  let header = headers.find(header => /accept-encoding/i.test(header.name));
  if (header) {
    header.value = header.value.split(/\s*,\s*/).concat('br').join(', ');
  }
  return { requestHeaders: headers }
}, {
  urls: ['*://*/*']
}, [
  'blocking', 'requestHeaders'
]);
