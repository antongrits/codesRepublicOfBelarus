//
//  JSUserScripts.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 5.04.24.
//

import Foundation

let addMetaTeg = """
    document.querySelectorAll('meta').forEach(meta => meta.remove());
    let metaTag = document.createElement('meta');
    metaTag.setAttribute('name', 'viewport');
    metaTag.setAttribute('content', 'width=device-width, initial-scale=1.0, user-scalable=no');
    document.head.appendChild(metaTag);
"""

func linkCss() -> String {
    guard let path = Bundle.main.path(forResource: "etalon", ofType: "css"),
          let cssString = try? String(contentsOfFile: path).components(separatedBy: .newlines).joined() else {
        return ""
    }
    
    return """
        let style = document.createElement('style');
        style.innerHTML = '\(cssString)';
        document.head.appendChild(style);
    """
}

let removeHref = """
    let spans = document.querySelectorAll('.changeadd');
    spans.forEach(function(span) {
        span.innerHTML = span.innerHTML.replace(/&lt;[^&]*&gt;/g, '');
    });
    spans = document.querySelectorAll('.changeadd a');
    spans.forEach(function(span) {
        span.removeAttribute('href');
    });
"""

let removeLinks = """
    const elementsWithHref = document.querySelectorAll('[href]');

    elementsWithHref.forEach(function(element) {
        element.removeAttribute('href');
    });
"""

let hideRekviziti = """
    let elements = document.querySelectorAll('.rekviziti');

    elements.forEach(element => {
        let content = element.textContent.trim();
        if (content.includes('——') || content.includes('__')) {
            element.style.display = 'none';
        }
    });
"""

let removeNbsp = """
    function replaceNbsp(className) {
        let elements = document.getElementsByClassName(className);
        for (let i = 0; i < elements.length; i++) {
            let element = elements[i];
            element.innerHTML = element.innerHTML.replace(/&nbsp;/g, ' ');
        }
    }

    replaceNbsp("contenttext");
    replaceNbsp("podrazdel");
    replaceNbsp("chapter");
"""

let getArticles = """
    const articles = document.querySelectorAll('.article');

    articles.forEach(function(article) {
        const supTags = article.querySelectorAll('sup');
        supTags.forEach(function(supTag) {
            const text = supTag.innerText;
            const dot = document.createTextNode('/');
            supTag.parentNode.replaceChild(dot, supTag);
            article.insertBefore(document.createTextNode(text), dot.nextSibling);
        });
    });

    let articleObjects = [];

    articles.forEach(function(article) {
        let className = article.className;
        let idName = article.id;
        let text = article.innerText.trim();
        articleObjects.push({
            className: className,
            idName: idName,
            text: text
        });
    });

    JSON.stringify(articleObjects);
"""

let addBookmarks = """
    const allArticles = document.querySelectorAll('.article');

    allArticles.forEach(function(article) {
        const wrapper = document.createElement('div');
        wrapper.classList.add('article-wrapper');
        
        article.parentNode.insertBefore(wrapper, article);
        wrapper.appendChild(article);
        
        const articleButton = document.createElement('button');
        articleButton.classList.add('article-button');
        articleButton.id = article.id;
        articleButton.innerHTML = `<?xml version="1.0" encoding="iso-8859-1"?>
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
    </svg>`;
        
        articleButton.addEventListener('click', function() {
            const allButtons = document.querySelectorAll('.article-button');
            let svgId;
            allButtons.forEach(function(button) {
                if (button.id === article.id) {
                    svgId = button.querySelector('svg').id;
                }
            });
            const articleObject = JSON.stringify({
                className: article.classList[0],
                idName: article.id,
                svgId: svgId
            });
            window.webkit.messageHandlers.messageAppHandler.postMessage(articleObject);
        });
        
        wrapper.insertBefore(articleButton, article);
    });
"""
