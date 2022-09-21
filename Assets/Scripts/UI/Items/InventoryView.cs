using Items;
using UnityAtoms;
using UnityAtoms.BaseAtoms;
using UnityEngine;
using Utils.Extensions;

namespace UI.Items
{
    public class InventoryView : MonoBehaviour, IAtomListener<Item>
    {
        [SerializeField] private ItemValueList _inventory;
        [SerializeField] private ItemEvent _inventoryChangedEvent;
        
        [SerializeField, Space] private RectTransform _container;
        [SerializeField] private ItemView _itemViewPrefab;

        private void Start()
        {
            _inventoryChangedEvent.RegisterListener(this);
        }

        private void OnDisable()
        {
            _inventoryChangedEvent.UnregisterListener(this);
        }

        public void OnEventRaised(Item item)
        {
            UpdateInventoryUi();
        }

        private void UpdateInventoryUi()
        {
            _container.ClearChildren();
            foreach (var item in _inventory)
            {
                var prefab = item.InventoryViewPrefab != null ? item.InventoryViewPrefab : _itemViewPrefab;
                var itemView = Instantiate(prefab, _container);
                itemView.Initialize(item);
            }
        }
    }
}