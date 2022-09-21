﻿using System.Collections.Generic;
using UnityAtoms.BaseAtoms;
using UnityEngine;

namespace Items
{
    public class InventoryReseter : MonoBehaviour
    {
        [SerializeField] private ItemValueList _inventory;

        private void Start()
        {
            ClearInventory();
        }

        private void ClearInventory()
        {
            var items = new List<Item>(_inventory);
            foreach (var item in items)
            {
                _inventory.RemoveItem(item);
            }
        }
    }
}