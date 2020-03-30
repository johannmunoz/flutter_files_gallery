class FileIcons {
  static String getFileIcon(String fileExtension) {
    switch (fileExtension) {
      case 'doc':
      case 'docx':
      case 'rtf':
        return '/assets/fileicons/word.svg';
        break;
      case '.pdf':
        return '/assets/fileicons/pdf.svg';
        break;
      case '.xlsx':
      case '.xls':
      case '.csv':
      case '.tsv':
        return '/assets/fileicons/table.svg';
        break;
      case '.html':
      case '.htm':
      case '.xhtml':
      case '.html_vm':
      case '.asp':
        return '/assets/fileicons/html.svg';
        break;

      case '.md':
      case '.markdown':
      case '.rst':
        return '/assets/fileicons/markdown.svg';
        break;
      case '.yaml':
      case '.YAML-tmLanguage':
      case '.yml':
        return '/assets/fileicons/yaml.svg';
        break;
      case '.xml':
      case '.plist':
      case '.xsd':
      case '.dtd':
      case '.xsl':
      case '.xslt':
      case '.resx':
      case '.iml':
      case '.xquery':
      case '.tmLanguage':
      case '.manifest':
      case '.project':
        return '/assets/fileicons/xml.svg';
        break;
      case '.png':
      case '.jpeg':
      case '.jpg':
      case '.gif':
      case '.svg':
      case '.ico':
      case '.tif':
      case '.tiff':
      case '.psd':
      case '.psb':
      case '.ami':
      case '.apx':
      case '.bmp':
      case '.bpg':
      case '.brk':
      case '.cur':
      case '.dds':
      case '.dng':
      case '.exr':
      case '.fpx':
      case '.gbr':
      case '.img':
      case '.jbig2':
      case '.jb2':
      case '.jng':
      case '.jxr':
      case '.pbm':
      case '.pgf':
      case '.pic':
      case '.raw':
      case '.webp':
      case '.eps':
        return '/assets/fileicons/image.svg';
        break;
      case '.tex':
      case '.cls':
      case '.sty':
        return '/assets/fileicons/tex.svg';
        break;
      case '.pptx':
      case '.ppt':
      case '.pptm':
      case '.potx':
      case '.potm':
      case '.ppsx':
      case '.ppsm':
      case '.pps':
      case '.ppam':
      case '.ppa':
        return '/assets/fileicons/powerpoint.svg';
        break;
      case '.mov':
      case '.qt':
      case '.wmv':
      case '.yuv':
      case '.rm':
      case '.rmvb':
      case '.mp4':
      case '.m4v':
      case '.mpg':
      case '.mp2':
      case '.mpeg':
      case '.mpe':
      case '.mpv':
      case '.m2v':
        return '/assets/fileicons/video.svg';
        break;
      case '.mp3':
      case '.flac':
      case '.m4a':
      case '.wma':
      case '.aiff':
        return '/assets/fileicons/audio.svg';
        break;
      case '.txt':
        return '/assets/fileicons/document.svg';
        break;
      default:
        return '/assets/fileicons/file.svg';
    }
  }
}
