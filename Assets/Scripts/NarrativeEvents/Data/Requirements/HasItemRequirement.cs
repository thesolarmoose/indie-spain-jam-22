using System;
using Items;
using UnityAtoms.BaseAtoms;
using UnityEngine;
using Utils.Attributes;
using Utils.Serializables;

namespace NarrativeEvents.Data.Requirements
{
    [Serializable]
    public class HasItemRequirement : ISerializablePredicate, IDrawableRequirement
    {
        [SerializeField, AutoProperty(AutoPropertyMode.Asset)] private ItemValueList _inventory;
        [SerializeField] private Item _item;
        [SerializeField] private bool _contains;
        
        public bool IsMet()
        {
            bool contains = _inventory.Contains(_item);
            bool isMet = !(contains ^ _contains);
            return isMet;
        }

        public Sprite GetSprite()
        {
            return _item.Image;
        }
    }
}