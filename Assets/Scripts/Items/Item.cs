﻿using NaughtyAttributes;
 using UI.Items;
 using UnityAtoms.BaseAtoms;
using UnityEditor;
using UnityEngine;
using UnityEngine.Events;
 using UnityEngine.Localization;

 namespace Items
{
    [CreateAssetMenu(fileName = "Item", menuName = "Items/Item", order = 0)]
    public class Item : ScriptableObject
    {
        [Header("Appearance")]
        [SerializeField] private string _name;
        [SerializeField] private LocalizedString _description;
        [SerializeField, ShowAssetPreview] private Sprite _image;
        [SerializeField] private ItemView _inventoryViewPrefab;
        
        [Space(24), Header("Behaviour")]
        [SerializeField] private UnityEvent _onEquipped;
        [SerializeField] private UnityEvent _onUnequipped;

        public string Name => _name;

        public LocalizedString Description => _description;

        public Sprite Image => _image;

        public ItemView InventoryViewPrefab => _inventoryViewPrefab;

        public void Equip()
        {
            _onEquipped?.Invoke();
            OnEquip();
        }

        public void UnEquip()
        {
            _onUnequipped?.Invoke();
            OnUnEquip();
        }

        protected virtual void OnEquip(){}
        protected virtual void OnUnEquip(){}

#if UNITY_EDITOR

        private ItemValueList GetInventory()
        {
            string path = "Assets/Data/Items/_Inventory.asset";
            var inventory = AssetDatabase.LoadAssetAtPath<ItemValueList>(path);
            return inventory;
        }
        
        [ContextMenu("Equip")]
        private void EditorEquip()
        {
            GetInventory().AddItem(this);
        }
        
        [ContextMenu("UnEquip")]
        private void EditorUnEquip()
        {
            GetInventory().RemoveItem(this);
        }
#endif
        
    }
}