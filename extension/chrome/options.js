// Saves options to chrome.storage
const saveOptions = () => {
    const linkServerURL = document.getElementById('link-server').value;
    const linkServerAPIKey = document.getElementById(
        'link-server-api-key',
    ).value;

    chrome.storage.local.set({ linkServerURL, linkServerAPIKey }, () => {
        // Update status to let user know options were saved.
        const status = document.getElementById('status');
        status.textContent = 'Options saved.';
        setTimeout(() => {
            status.textContent = '';
        }, 750);
    });
};

// Restores select box and checkbox state using the preferences
// stored in chrome.storage.
const restoreOptions = () => {
    chrome.storage.local.get(
        { linkServerURL: 'http://localhost:5000/go', linkServerAPIKey: '' },
        (items) => {
            document.getElementById('link-server').value = items.linkServerURL;
            document.getElementById('link-server-api-key').value =
                items.linkServerAPIKey;
        },
    );
};

document.addEventListener('DOMContentLoaded', restoreOptions);
document.getElementById('save').addEventListener('click', saveOptions);
