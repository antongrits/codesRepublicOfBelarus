const bookmarkChecked = `<svg
      version="1.1"
      id="bookmarkChecked"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      width="45px"
      height="45px"
      viewBox="0 0 55 55"
      xml:space="preserve"
    >
      <g>
        <path
          style="fill: #d75a4a"
          d="M21,0H5v53.444c0,0.495,0.598,0.742,0.948,0.393L21,38.784l15.052,15.052
        c0.35,0.35,0.948,0.102,0.948-0.393V0H21z"
        />
        <rect x="5" style="fill: #c03b2b" width="32" height="11" />
        <g>
          <circle style="fill: #26b999" cx="38" cy="43" r="12" />
          <path
            style="fill: #ffffff"
            d="M44.571,37.179c-0.455-0.316-1.077-0.204-1.392,0.25l-5.596,8.04l-3.949-3.242
            c-0.426-0.351-1.057-0.288-1.407,0.139c-0.351,0.427-0.289,1.057,0.139,1.407l4.786,3.929c0.18,0.147,0.404,0.227,0.634,0.227
            c0.045,0,0.091-0.003,0.137-0.009c0.276-0.039,0.524-0.19,0.684-0.419l6.214-8.929C45.136,38.118,45.024,37.495,44.571,37.179z"
          />
        </g>
      </g>
    </svg>`

const bookmarkNotChecked = `<?xml version="1.0" encoding="iso-8859-1"?>
    <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
    <svg
      version="1.1"
      id="bookmarkNotChecked"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      width="45px"
      height="45px"
      viewBox="0 0 55 55"
      xml:space="preserve"
    >
      <g>
        <path
          style="fill: #d75a4a"
          d="M21,0H5v53.444c0,0.495,0.598,0.742,0.948,0.393L21,38.784l15.052,15.052
        c0.35,0.35,0.948,0.102,0.948-0.393V0H21z"
        />
        <rect x="5" style="fill: #c03b2b" width="32" height="11" />
        <g>
          <circle style="fill: #71c386" cx="38" cy="43" r="12" />
          <path
            style="fill: #ffffff"
            d="M44,42h-5v-5c0-0.552-0.448-1-1-1s-1,0.448-1,1v5h-5c-0.552,0-1,0.448-1,1s0.448,1,1,1h5v5
            c0,0.552,0.448,1,1,1s1-0.448,1-1v-5h5c0.552,0,1-0.448,1-1S44.552,42,44,42z"
          />
        </g>
      </g>
    </svg>`

let currSelected = -1;
let WKWebView_SearchResultCount = 0;

function WKWebView_HighlightAllOccurencesOfStringForElement(element, keyword) {
    if (element) {
        if (element.nodeType == 3) {
            while (true) {
                let value = element.nodeValue;
                let idx = value.toLowerCase().indexOf(keyword);
                
                if (idx < 0) break;
                
                let span = document.createElement("span");
                let text = document.createTextNode(value.substr(idx, keyword.length));
                span.appendChild(text);
                span.setAttribute("class", "WKWebView_Highlight");
                span.style.backgroundColor = "yellow";
                span.style.color = "black";
                text = document.createTextNode(value.substr(idx + keyword.length));
                element.deleteData(idx, value.length - idx);
                let next = element.nextSibling;
                element.parentNode.insertBefore(span, next);
                element.parentNode.insertBefore(text, next);
                element = text;
                WKWebView_SearchResultCount++;
            }
        } else if (element.nodeType == 1) {
            if (element.style.display != "none" && element.nodeName.toLowerCase() != "select") {
                for (let i = element.childNodes.length - 1; i >= 0; i--) {
                    WKWebView_HighlightAllOccurencesOfStringForElement(element.childNodes[i], keyword);
                }
            }
        }
    }
}

function WKWebView_SearchNext() {
    WKWebView_jump(1);
}
function WKWebView_SearchPrev() {
    WKWebView_jump(-1);
}

function WKWebView_jump(increment) {
    prevSelected = currSelected;
    currSelected = currSelected + increment;
    
    if (currSelected < 0) {
        currSelected = WKWebView_SearchResultCount + currSelected;
    }
    
    if (currSelected >= WKWebView_SearchResultCount) {
        currSelected = currSelected - WKWebView_SearchResultCount;
    }
    
    prevEl = document.getElementsByClassName("WKWebView_Highlight")[prevSelected];
    
    if (prevEl) {
        prevEl.style.backgroundColor = "yellow";
    }
    let el = document.getElementsByClassName("WKWebView_Highlight")[currSelected];
    el.style.backgroundColor = "green";
    
    el.scrollIntoView({ behavior: "smooth" });
}

function WKWebView_HighlightAllOccurencesOfString(keyword) {
    WKWebView_RemoveAllHighlights();
    WKWebView_HighlightAllOccurencesOfStringForElement(document.body, keyword.trim().toLowerCase());
}

function WKWebView_RemoveAllHighlightsForElement(element) {
    if (element) {
        if (element.nodeType == 1) {
            if (element.getAttribute("class") == "WKWebView_Highlight") {
                let text = element.removeChild(element.firstChild);
                element.parentNode.insertBefore(text, element);
                element.parentNode.removeChild(element);
                return true;
            } else {
                let normalize = false;
                for (let i = element.childNodes.length - 1; i >= 0; i--) {
                    if (WKWebView_RemoveAllHighlightsForElement(element.childNodes[i])) {
                        normalize = true;
                    }
                }
                if (normalize) {
                    element.normalize();
                }
            }
        }
    }
    return false;
}

function WKWebView_RemoveAllHighlights() {
    
    WKWebView_SearchResultCount = 0;
    currSelected = -1;
    
    WKWebView_RemoveAllHighlightsForElement(document.body);
}

// Navigation
function scrollToElement(className, id) {
    const elementsWithClass = document.querySelectorAll(`.${className}`);
    elementsWithClass.forEach(el => {
        if (el.id === id) {
            el.scrollIntoView({ behavior: "smooth" });
            return;
        }
    });
}

// Bookmark svg-icon
function setSvgIconByClassAndId(className, id, svgId) {
    const elements = document.querySelectorAll("." + className + "-button");
    
    elements.forEach(el => {
        if (el.id === id) {
            el.innerHTML = (svgId === "bookmarkChecked") ? bookmarkChecked : bookmarkNotChecked
            return
        }
    });
}

function resetSvgIcons() {
    const elements = document.querySelectorAll(".article-button");
    
    elements.forEach(el => {
        el.innerHTML = bookmarkNotChecked
    });
}
