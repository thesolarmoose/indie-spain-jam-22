﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityAtoms.BaseAtoms;
using UnityEditor;
using UnityEngine;
using Utils;
using Utils.Attributes;
using Utils.Serializables;

namespace Items
{
    [CreateAssetMenu(fileName = "ItemsPool", menuName = "Items/ItemsPool", order = 0)]
    public class ItemsPool : ScriptableObject
    {
        [SerializeField, ToStringLabel] private List<ItemProbability> _items;

        public List<Item> GetItems(List<Item> except, int count)
        {
            var items = new List<Item>();
            var exceptItems = new List<Item>(except);
            while (count > 0)
            {
                var item = GetItem(exceptItems);
                if (item == null)
                    break;
                
                items.Add(item);
                exceptItems.Add(item);
                
                count--;
            }

            return items;
        }
        
        public Item GetItem(List<Item> except)
        {
            var items = new List<ItemProbability>(_items);
            items.RemoveAll(itemProb =>
            {
                bool isException = except.Contains(itemProb.Item);
                bool cantAppear = !itemProb.CanAppear;
                return isException || cantAppear;
            });

            if (items.Count > 0)
            {
                var weights = items.ConvertAll(itemProb => itemProb.ProbabilityWeight);
                int randomIndex = RandomUtils.GetRandomWeightedIndex(weights);

                var randomItem = items[randomIndex].Item;
                return randomItem;
            }

            return null;
        }

#if UNITY_EDITOR
        [ContextMenu("Initialize from current folder")]
        private void InitializeFromFolder()
        {
            var currentPath = AssetDatabase.GetAssetPath(this);
            var directory = Path.GetDirectoryName(currentPath);
            var items = AssetDatabase.FindAssets("t:Item", new []{ directory })
                .Select(AssetDatabase.GUIDToAssetPath)
                .Select(AssetDatabase.LoadAssetAtPath<Item>);
            foreach (var item in items)
            {
                bool contains = _items.Exists(ip => ip.Item == item);
                if (!contains)
                {
                    _items.Add(new ItemProbability(null, item, 1));
                }
            }
        }
#endif
    }

    [Serializable]
    public class ItemProbability
    {
        [SerializeReference, SubclassSelector] private ISerializablePredicate _restriction;
        [SerializeField] private Item _item;
        [SerializeField] private float _probabilityWeight;
        // appear condition

        public Item Item => _item;

        public float ProbabilityWeight => _probabilityWeight;

        public bool CanAppear => _restriction == null || _restriction.IsMet();

        public ItemProbability(ISerializablePredicate restriction, Item item, float probabilityWeight)
        {
            _restriction = restriction;
            _item = item;
            _probabilityWeight = probabilityWeight;
        }

        public ItemProbability() : this(null, null, 1)
        {
        }

        public override string ToString()
        {
            return $"{_item.Name}: {_probabilityWeight}";
        }
    }
}