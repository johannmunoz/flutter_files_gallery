# flutter-files-gallery

## Get started

Add this to your package's `pubspec.yaml` file:

```
# Where TAG_VERSION is the specific git tag to use
files_gallery:
  git:
    url: https://github.com/resvu/flutter-files-gallery.git
    ref: TAG_VERSION
```

## ShowGallery

Add the `ShowGallery` widget populated with the files to display and the action to perform on delete.

```dart
ShowGallery(
    urls: urls
        .map(
            (item) => GalleryUrl(
            filename: item.value?.name,
            url: item.id,
            ),
        )
        .toList(),
    onDeleteNetworkFile: (index) =>
        setState(() => urls.removeAt(index)),
)
```

Set `readonly: true` to hide delete button.

## SelectableGallery

Add the `SelectableGallery` widget populated with the files to display and the list of indexes of files selected.

```dart
SelectableGallery(
    urls: urls
        .map(
            (item) => GalleryUrl(
            filename: item.value?.name,
            url: item.id,
            ),
        )
        .toList(),
    onSelectedUrls: (indexes) {
        setState(() => selectedFiles = indexes);
    },
)
```
Set `reverse: true` to return indexes on reverse.
