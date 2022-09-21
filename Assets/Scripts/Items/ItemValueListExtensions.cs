﻿using UnityAtoms.BaseAtoms;

namespace Items
{
    public static class ItemValueListExtensions
    {
        public static void AddItem(this ItemValueList list, Item item)
        {
            list.Add(item);
            item.Equip();
        }
        
        public static void RemoveItem(this ItemValueList list, Item item)
        {
            if (list.Contains(item))
            {
                list.Remove(item);
                item.UnEquip();
            }
        }
    }
}